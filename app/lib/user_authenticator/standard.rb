# frozen_string_literal: true

class UserAuthenticator::Standard < UserAuthenticator
  class AuthenticationError::StandardError < StandardError; end

  def initialize(login, password); end

  def perform
    raise AuthenticationError
  end
end
