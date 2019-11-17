# frozen_string_literal: true

class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :slug

  belongs_to :user
  has_many :comments
end
