# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'alice' }
    sequence(:login) { |n| "alice #{n}" }
    email { 'github@gmail.com' }
    url { 'http://github/url' }
    avatar_url { 'http://github/avatar_url' }
    provider { 'github' }
  end
end
