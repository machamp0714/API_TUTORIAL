# frozen_string_literal: true

class ArticleSerializer
  include FastJsonapi::ObjectSerializer

  set_type :articles
  attributes :title, :content, :slug

  belongs_to :user
  has_many :comments
end
