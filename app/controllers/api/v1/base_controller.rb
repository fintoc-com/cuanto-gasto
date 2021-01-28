class Api::V1::BaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  include ApiErrorConcern

  self.responder = ApiResponder

  respond_to :json
end
