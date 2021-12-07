class Api::V1::FintocController < Api::V1::BaseController
  FINTOC_API_KEY = ENV.fetch('FINTOC_API_KEY')

  def show
    result = { status: 'syncing' }
    key = "cuantogasto:#{params.permit(:id)[:id]}"
    if REDIS_CONNECTION.exists?(key)
      link_token = REDIS_CONNECTION.get(key)

      @link = client.get_link(link_token)
      @credit_cards = @link.find_all(type: 'credit_card')

      if @credit_cards.none? { |cc| cc.refreshed_at.nil? }
        result = calculate_result
      end
    end
    render json: result, status: :ok
  end

  def webhook
    key = "cuantogasto:#{params[:id]}"
    if REDIS_CONNECTION.exists?(key)
      REDIS_CONNECTION.set(key, params[:data][:link_token])
      REDIS_CONNECTION.expire(key, 1800) # expire link_token in 30 minutes
    end
  end

  private

  def client
    @client ||= Fintoc::Client.new(FINTOC_API_KEY)
  end

  def calculate_result
    expenses = calculate_expenses

    result_row = Result.find_or_create_by(link_id: @link.id)
    result_row.update!(rappi_result: -expenses[:rappi],
                       uber_eats_result: -expenses[:uber_eats],
                       uber_result: -expenses[:uber],
                       total_result: -(expenses[:rappi] + expenses[:uber_eats] + expenses[:uber]))

    { status: 'completed', expenses: expenses, investment: calculate_investment, percentiles: calculate_percentiles(expenses) }
  end

  def calculate_expenses
    clp_rappi = clp_movements.filter { |mov| /rappi/i.match?(mov.description) }
                        .map(&:amount)
                        .sum
                        .to_i
    usd_rappi = usd_movements.filter { |mov| /rappi/i.match?(mov.description) }
                        .map(&:amount)
                        .sum * usd_to_clp / 100
                        .to_i
    clp_uber_eats = clp_movements.filter { |mov| /uber.*eats/i.match?(mov.description) }
                        .map(&:amount)
                        .sum
                        .to_i
    usd_uber_eats = usd_movements.filter { |mov| /uber.*eats/i.match?(mov.description) }
                        .map(&:amount)
                        .sum * usd_to_clp / 100
                        .to_i
    clp_uber = clp_movements.filter { |mov| /uber.*trip/i.match?(mov.description) }
                        .map(&:amount)
                        .sum
                        .to_i
    usd_uber = usd_movements.filter { |mov| /uber.*trip/i.match?(mov.description) }
                        .map(&:amount)
                        .sum * usd_to_clp / 100
                        .to_i
    {
      rappi: (clp_rappi + usd_rappi),
      uber_eats: (clp_uber_eats + usd_uber_eats),
      uber: (clp_uber + usd_uber)
    }
  end

  def calculate_investment
    clp_rappi = clp_movements.filter { |mov| /rappi/i.match?(mov.description) }
                        .map { |mov| mov.amount * fintual[mov.post_date.to_date.to_formatted_s] }
                        .sum
                        .to_i
    usd_rappi = usd_movements.filter { |mov| /rappi/i.match?(mov.description) }
                        .map { |mov| mov.amount * fintual[mov.post_date.to_date.to_formatted_s] }
                        .sum * usd_to_clp / 100
                        .to_i
    clp_uber_eats = clp_movements.filter { |mov| /uber.*eats/i.match?(mov.description) }
                        .map { |mov| mov.amount * fintual[mov.post_date.to_date.to_formatted_s] }
                        .sum
                        .to_i
    usd_uber_eats = usd_movements.filter { |mov| /uber.*eats/i.match?(mov.description) }
                        .map { |mov| mov.amount * fintual[mov.post_date.to_date.to_formatted_s] }
                        .sum * usd_to_clp / 100
                        .to_i
    clp_uber = clp_movements.filter { |mov| /uber.*trip/i.match?(mov.description) }
                        .map { |mov| mov.amount * fintual[mov.post_date.to_date.to_formatted_s] }
                        .sum
                        .to_i
    usd_uber = usd_movements.filter { |mov| /uber.*trip/i.match?(mov.description) }
                        .map { |mov| mov.amount * fintual[mov.post_date.to_date.to_formatted_s] }
                        .sum * usd_to_clp / 100
                        .to_i
    {
      rappi: -1 * (clp_rappi + usd_rappi),
      uber_eats: -1 * (clp_uber_eats + usd_uber_eats),
      uber: -1 * (clp_uber + usd_uber)
    }
  end

  def clp_movements
    @clp_movements ||= movements('CLP')
  end

  def usd_movements
    @usd_movements ||= movements('USD')
  end

  def movements(currency)
    @credit_cards.filter { |cc| cc.currency == currency }
                 .map { |cc| cc.get_movements(since: '2021-01-01', until: '2021-12-31', per_page: 300).force }
                 .flatten
  end

  def calculate_percentiles(expenses)
    rappi = percentile_arrays.find { |x| x[:rappi] > -expenses[:rappi] }.try(:[], :p) || 0.99
    uber = percentile_arrays.find { |x| x[:uber] > -expenses[:uber] }.try(:[], :p) || 0.99
    uber_eats = percentile_arrays.find { |x| x[:uber_eats] > -expenses[:uber_eats] }.try(:[], :p) || 0.99
    total_expenses = expenses[:rappi] + expenses[:uber] + expenses[:uber_eats]
    total = percentile_arrays.find { |x| x[:total] > -total_expenses }.try(:[], :p) || 0.99

    { rappi: rappi.to_f, uber_eats: uber_eats.to_f, uber: uber.to_f, total: total.to_f }
  end

  def percentile_arrays
    sql = <<-SQL
      SELECT k,
        PERCENTILE_DISC(k) WITHIN GROUP ( ORDER BY rappi_result ),
        PERCENTILE_DISC(k) WITHIN GROUP ( ORDER BY uber_result ),
        PERCENTILE_DISC(k) WITHIN GROUP ( ORDER BY uber_eats_result ),
        PERCENTILE_DISC(k) WITHIN GROUP ( ORDER BY total_result )
        FROM results, generate_series(0.01, 1, 0.01) as k
        GROUP BY k
    SQL
    @percentile_arrays ||= ActiveRecord::Base.connection.execute(sql).values.map do |tup|
      { p: tup[0], rappi: tup[1], uber: tup[2], uber_eats: tup[3], total: tup[4] }
    end
  end

  def calculate_delivery(regex); end

  def usd_to_clp
    @usd_to_clp ||= begin
      today = Time.now.strftime("%d-%m-%Y")
      resp = HTTParty.get("https://mindicador.cl/api/dolar/#{today}")
      resp['data']['serie'].first['valor'].to_i
    rescue => exception
      840
    end
  end

  def fintual
    @fintual ||= begin
      # moderate pit
      resp = HTTParty.get("https://fintual.cl/api/real_assets/187/days?from_date=2021-01-01")
      last_day = resp['data'].last['attributes']['price']
      arr = resp['data'].map do |x|
        { x['attributes']['date'] => (last_day / x['attributes']['price']) }
      end
      arr.reduce(:merge)
    end
  end
end
