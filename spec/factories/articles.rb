# frozen_string_literal: true

FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "MyString #{n}" }
    sequence(:content) { |n| "MyText #{n}" }
    sequence(:slug) { |n| "MyString #{n}" }
    association :user
  end
end
