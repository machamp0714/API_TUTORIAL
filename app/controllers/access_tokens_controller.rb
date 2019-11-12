# frozen_string_literal: true

class AccessTokensController < ApplicationController
  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

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

  private

  def authentication_error
    error = {
      'status' => '401',
      'source' => { 'pointer' => '/code' },
      'title' => 'Authentication Invalid',
      'detail' => 'You must provide valid code in order to exchange it for token.'
    }

    render json: { 'errors': [error] }, status: 401
  end
end
