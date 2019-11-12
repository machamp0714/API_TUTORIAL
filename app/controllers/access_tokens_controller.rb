# frozen_string_literal: true

class AccessTokensController < ApplicationController
  rescue_from UserAuthenticator::AuthenticationError, with: :authentication_error

  def create
    authenticator = UserAuthenticator.new(params[:code])
    authenticator.perform
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