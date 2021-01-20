class Api::V1::SessionController < Api::V1::BaseController
  def create
    session = SecureRandom.base58(24)
    REDIS_CONNECTION.set("cuantogasto:#{session}", "")
    render json: { session: session }, status: :ok
  end
end
