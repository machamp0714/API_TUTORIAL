# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'forbidden_request' do
  let(:authorization_error) do
    {
      'status' => '403',
      'source' => { 'pointer' => '/headers/authorization' },
      'title' => 'Not authorized',
      'detail' => 'You have no right to access this resource.'
    }
  end

  it 'should return 403 code' do
    subject
    expect(response).to have_http_status(:forbidden)
  end

  it 'should return error body' do
    subject
    expect(json['error']).to eq(authorization_error)
  end
end
