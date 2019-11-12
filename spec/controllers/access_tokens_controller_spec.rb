# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  describe '#create' do
    context 'when invalid request' do
      it 'should return 401 code' do
        post :create
        expect(response).to have_http_status 401
      end
    end

    context 'when valid request' do
      it 'should return 201 code' do
        post :create
        expect(response).to have_http_status 201
      end
    end
  end
end
