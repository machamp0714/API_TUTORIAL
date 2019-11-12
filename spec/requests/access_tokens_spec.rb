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
  end
end
