# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccessTokens', type: :request do
  describe '#create' do
    context 'when invalid request' do
      let(:authorization_error) do
        {
          'status' => '401',
          'source' => { 'pointer' => '/code' },
          'title' => 'Authentication Invalid',
          'detail' => 'You must provide valid code in order to exchange it for token.'
        }
      end

      it 'when not code provided' do
        post login_path
        expect(response).to have_http_status 401
        expect(json['errors']).to include authorization_error
      end

      it 'when code is invalid' do
        post login_path, params: { code: 'invalid_code' }
        expect(response).to have_http_status 401
        expect(json['errors']).to include(authorization_error)
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

  describe 'DELETE #destroy' do
    context 'when no authorization header provided' do
      subject { delete logout_path }

      it_behaves_like 'forbidden_request'
    end

    context 'when invalid authorization header provided' do
      subject { delete logout_path, headers: { authorization: 'Invalid Token' } }

      it_behaves_like 'forbidden_request'
    end

    context 'when valid request' do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }
      let(:headers) do
        { authorization: "Bearer #{access_token.token}" }
      end

      subject { delete logout_path, headers: headers }

      it 'should return 204 code' do
        subject
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
