# frozen_string_literal: true

class AccessTokenSerializer < ActiveModel::Serializer
  attributes :id, :token
end
