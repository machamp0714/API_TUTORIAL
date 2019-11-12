# frozen_string_literal: true

class AccessTokensController < ApplicationController
  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform

    render json: authenticator.access_token, status: :created
  end

  def destroy
    error = {
      'status' => '403',
      'source' => { 'pointer' => '/headers/authorization' },
      'title' => 'Not authorized',
      'detail' => 'You have no right to access this resource.'
    }
    render json: { error: error }, status: :forbidden
  end
end
