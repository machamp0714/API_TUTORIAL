# frozen_string_literal: true

require 'rails_helper'

describe UserAuthenticator::Oauth do
  describe '#perform' do
    let(:authenticator) { described_class.new('sample_code') }
    subject { authenticator.perform }

    context 'when code is incorrect' do
      let(:error) { double('Sawyer::Resource', error: 'bad_verification_code') }

      before do
        allow(Octokit::Client.new).to receive(:exchange_code_for_token).and_return(error)
      end

      it 'should raise error' do
        expect { subject }.to raise_error(
          UserAuthenticator::Oauth::AuthenticationError
        )
        expect(authenticator.user).to be_nil
      end
    end

    context 'when code is correct' do
      let(:user_data) do
        {
          login: 'sample',
          url: 'https://sample/url',
          avatar_url: 'https://sample/avatar/url',
          name: 'sample_name'
        }
      end

      before do
        # allow_any_instance_ofの挙動について理解する
        allow_any_instance_of(Octokit::Client).to receive(
          :exchange_code_for_token
        ).and_return('validaccesstoken')

        allow_any_instance_of(Octokit::Client).to receive(
          :user
        ).and_return(user_data)
      end

      it 'should create a new user when dose not exist' do
        expect { subject }.to change { User.count }.by(1)
        expect(User.last.name).to eq user_data[:name]
      end

      it 'should reuse registered user' do
        user = create :user, user_data
        expect { subject }.not_to change { User.count }
        expect(authenticator.user).to eq(user)
      end

      it 'should create access token and set token' do
        expect { subject }.to change { AccessToken.count }.by(1)
        expect(authenticator.access_token).to be_present
      end
    end
  end
end
