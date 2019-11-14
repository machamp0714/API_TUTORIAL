# frozen_string_literal: true

class AccessTokenSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  set_type :access_token
  attributes :token
end
