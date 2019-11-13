# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccessTokensController, type: :controller do
  describe 'DELETE #destroy' do
    subject { delete :destroy }
    let(:user) { create :user }
    let(:access_token) { user.create_access_token }

    before { request.headers['authorization'] = "Bearer #{access_token.token}" }

    it 'ログアウトできること' do
      expect { subject }.to change { AccessToken.count }.by(-1)
    end
  end
end
