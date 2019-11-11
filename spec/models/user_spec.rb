# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#Validations' do
    let(:user) { build :user }

    it 'loginがからである場合無効であること' do
      user.login = nil
      expect(user).to be_invalid
      expect(user.errors.messages[:login]).to include "can't be blank"
    end

    it 'loginの一意性が確保されていること' do
      other_user = create :user
      user.login = other_user.login
      expect(user).to be_invalid
    end

    it 'providerが空である場合、無効であること' do
      user.provider = nil
      expect(user).to be_invalid
      expect(user.errors.messages[:provider]).to include "can't be blank"
    end
  end
end
