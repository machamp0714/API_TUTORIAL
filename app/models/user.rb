# frozen_string_literal: true

class User < ApplicationRecord
  has_many :articles, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :access_token, dependent: :destroy

  validates :login, presence: true, uniqueness: { case_sensitive: true }
  validates :provider, presence: true
end
