# frozen_string_literal: true

class User < ApplicationRecord
  validates :login, presence: true, uniqueness: { case_sensitive: true }
  validates :provider, presence: true
end
