class Api::V1::FintocController < Api::V1::BaseController
  FINTOC_API_KEY = ENV.fetch('FINTOC_API_KEY')

  def show
    result = { status: 'syncing' }
    key = "cuantogasto:#{params.permit(:id)[:id]}"
    if REDIS_CONNECTION.exists?(key)
      link_token = REDIS_CONNECTION.get(key)

      link = client.get_link(link_token)
      @credit_cards = link.find_all(type: 'credit_card')

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
    { status: 'completed', expenses: calculate_expenses, investment: calculate_investment }
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
