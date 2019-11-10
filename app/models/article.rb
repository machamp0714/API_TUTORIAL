# frozen_string_literal: true

class Article < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: { case_sensitive: true }

  scope :recent, -> { order(created_at: :desc) }
end
