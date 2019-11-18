# frozen_string_literal: true

class UserAuthenticator::Standard < UserAuthenticator
  class AuthenticationError::StandardError < StandardError; end

  attr_reader :user

  def initialize(login, password)
    @login = login
    @password = password
  end

  def perform
    user = User.find_by(login: login)

    if user&.authenticate(password)
      @user = user
    else
      raise AuthenticationError
    end
  end

  private

  attr_reader :login, :password
end
