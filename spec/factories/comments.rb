# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    content { "MyText" }
    association :article
    association :user
  end
end
