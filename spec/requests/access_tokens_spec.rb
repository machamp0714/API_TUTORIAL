# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccessTokens', type: :request do
  describe '#create' do
    context 'when invalid request' do
      let(:error) do
        {
          'status' => '401',
          'source' => { 'pointer' => '/code' },
          'title' => 'Authentication Invalid',
          'detail' => 'You must provide valid code in order to exchange it for token.'
        }
      end
      # shared_examplesでリファクタリングする
      it 'when not code provided' do
        post login_path
        expect(response).to have_http_status 401
        expect(json['errors']).to include error
      end

      it 'when code is invalid' do
        post login_path, params: { code: 'invalid_code' }
        expect(response).to have_http_status 401
        expect(json['errors']).to include error
      end
    end

    context 'when valid requests' do
      let(:user_data) do
        {
          login: 'sample',
          url: 'https://sample/url',
          avatar_url: 'https://sample/avatar/url',
          name: 'sample_name'
        }
      end

      before do
        allow_any_instance_of(Octokit::Client).to receive(:exchange_code_for_token).and_return('validaccesstoken')
        allow_any_instance_of(Octokit::Client).to receive(:user).and_return(user_data)
      end

      subject { post login_path, params: { code: 'valid_code' } }

      it 'should return 201 code' do
        subject
        expect(response).to have_http_status 201
      end

      it 'should return json body' do
        expect { subject }.to change { User.count }.by(1)

        user = User.find_by(login: user_data[:login])
        expect(json_data['attributes']).to eq(
          'token' => user.access_token.token
        )
      end

      it 'should generate token once' do
        user = create :user, user_data
        user.create_access_token
        subject

        expect(json_data['attributes']['token']).to eq(user.access_token.token)
      end
    end
  end
end
