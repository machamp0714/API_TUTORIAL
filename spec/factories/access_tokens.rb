# frozen_string_literal: true

FactoryBot.define do
  factory :access_token do
    token { 'MyString' }
    association :user, factory: :user
  end
end
