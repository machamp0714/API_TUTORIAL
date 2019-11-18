# frozen_string_literal: true

require 'rails_helper'

describe UserAuthenticator do
  context 'when initialized with code' do
    let(:authenticator) { described_class.new(code: 'sample_code') }
    let(:authenticator_class) { UserAuthenticator::Oauth }

    describe '#initialize' do
      it 'should initialize proper authenticator' do
        expect(authenticator_class).to receive(:new).with('sample_code')
        authenticator
      end
    end
  end

  context 'when initialized with login & password' do
    let(:authenticator) { described_class.new(login: 'jsmith', password: 'password') }
    let(:authenticator_class) { UserAuthenticator::Standard }

    describe '#initialize' do
      it 'should initialize proper authenticator' do
        expect(authenticator_class).to receive(:new).with('jsmith', 'password')
        authenticator
      end

      let(:user) { create :user, login: 'jsmith', password: 'password' }
      before { user }

      it 'should create access_token and set token' do
        expect { authenticator.perform }.to change { AccessToken.count }.by(1)
        expect(authenticator.access_token).to be_present
      end
    end
  end
end
