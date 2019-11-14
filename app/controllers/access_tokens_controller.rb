# frozen_string_literal: true

class AccessTokensController < ApplicationController
  before_action :authorize!, only: :destroy

  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform
    serializer = AccessTokenSerializer.new(authenticator.access_token).serialized_json
    render json: serializer, status: :created
  end

  def destroy
    current_user.access_token.delete
  end
end
