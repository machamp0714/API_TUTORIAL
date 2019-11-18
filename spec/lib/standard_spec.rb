# frozen_string_literal: true

# 自力でテストを追加する

require 'rails_helper'

describe UserAuthenticator::Standard do
  describe '#perform' do
    let(:authenticator) { described_class.new('jsmith', 'password') }

    subject { authenticator.perform }

    shared_examples_for 'invalid authentication' do
      it 'should raise exeption' do
        expect { subject }.to raise_error(
          UserAuthenticator::Standard::AuthenticationError
        )
        expect(authenticator.user).to be_nil
      end
    end

    context 'when invalid login' do
      let(:user) { create :user, login: 'invalid', password: 'password' }
      before { user }
      it_behaves_like 'invalid authentication'
    end

    context 'when invalid password' do
      let(:user) { create :user, login: 'jsmith', password: 'invalid' }
      before { user }
      it_behaves_like 'invalid authentication'
    end

    context 'when params correct' do
      let(:user) { create :user, login: 'jsmith', password: 'password' }
      before { user }

      it 'should set the user found in db' do
        expect { subject }.to_not change { User.count }
        expect(authenticator.user).to eq(user)
      end
    end
  end
end
