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
    rappi = clp_movements.filter { |mov| /rappi/i.match?(mov.description) }
                         .map(&:amount)
                         .sum
    uber_eats = usd_movements.filter { |mov| /uber.*eats/i.match?(mov.description) }
                             .map(&:amount)
                             .sum * 730 / 100
                .to_i
    uber = usd_movements.filter { |mov| /uber.*trip/i.match?(mov.description) }
                        .map(&:amount)
                        .sum * 730 / 100
           .to_i
    { rappi: rappi, uber_eats: uber_eats, uber: uber }
  end

  def calculate_investment
    rappi = clp_movements.filter { |mov| /rappi/i.match?(mov.description) }
                         .map { |mov| mov.amount * fintual[mov.post_date.to_date.to_formatted_s] }
                         .sum
                         .to_i
    uber_eats = usd_movements.filter { |mov| /uber.*eats/i.match?(mov.description) }
                             .map { |mov| mov.amount * fintual[mov.post_date.to_date.to_formatted_s] }
                             .sum * 730 / 100
                .to_i
    uber = usd_movements.filter { |mov| /uber.*trip/i.match?(mov.description) }
                        .map { |mov| mov.amount * fintual[mov.post_date.to_date.to_formatted_s] }
                        .sum * 730 / 100
           .to_i
    { rappi: -1 * rappi, uber_eats: -1 * uber_eats, uber: -1 * uber }
  end

  def clp_movements
    @clp_movements ||= movements('CLP')
  end

  def usd_movements
    @usd_movements ||= movements('USD')
  end

  def movements(currency)
    @credit_cards.filter { |cc| cc.currency == currency }
                 .map { |cc| cc.get_movements(since: '2020-01-01', until: '2020-12-31', per_page: 300).force }
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

  def fintual
    @fintual ||= begin
      # moderate pit
      resp = HTTParty.get("https://fintual.cl/api/real_assets/187/days?from_date=2020-01-01")
      last_day = resp['data'].last['attributes']['price']
      arr = resp['data'].map do |x|
        { x['attributes']['date'] => (last_day / x['attributes']['price']) }
      end
      arr.reduce(:merge)
    end
  end
end
