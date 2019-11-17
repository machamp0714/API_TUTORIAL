# frozen_string_literal: true

class AccessTokensController < ApplicationController
  before_action :authorize!, only: :destroy

  def create
    authenticator = UserAuthenticator.new(authentication_params)
    authenticator.perform
    render json: authenticator.access_token, status: :created
  end

  def destroy
    current_user.access_token.delete
  end

  private

  def authentication_params
    params.permit(:code).to_h.symbolize_keys
  end
end
