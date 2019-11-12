# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AccessTokens', type: :request do
  describe '#create' do
    subject { post login_path }
    context 'when invalid request' do
      let(:error) do
        {
          'status' => '401',
          'source' => { 'pointer' => '/code' },
          'title' => 'Authentication Invalid',
          'detail' => 'You must provide valid code in order to exchange it for token.'
        }
      end

      it 'should return 401 code' do
        subject
        expect(response).to have_http_status 401
      end

      it 'should return error body' do
        subject
        expect(json['errors']).to include error
      end
    end

    context 'when valid request' do
      it 'should return 201 code' do
        post login_path
        expect(response).to have_http_status 201
      end
    end
  end
end
