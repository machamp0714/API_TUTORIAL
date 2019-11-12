# frozen_string_literal: true

class User < ApplicationRecord
  has_one :access_token, dependent: :destroy

  validates :login, presence: true, uniqueness: { case_sensitive: true }
  validates :provider, presence: true
end
