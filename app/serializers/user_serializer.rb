# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :avatar_url, :url, :name
end
