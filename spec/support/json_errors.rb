# frozen_string_literal: true

require 'rails_helper'

shared_examples_for 'unauthorized_oauth_request' do
  let(:authorization_error) do
    {
      'status' => '401',
      'source' => { 'pointer' => '/code' },
      'title' => 'Authentication Invalid',
      'detail' => 'You must provide valid code in order to exchange it for token.'
    }
  end

  it 'should return 401 status code' do
    subject

    expect(response).to have_http_status 401
  end

  it 'should return proper json body' do
    subject

    expect(json['errors']).to include(authorization_error)
  end
end

shared_examples_for 'unauthorized_standard_request' do
  let(:authorization_error) do
    {
      'status' => '401',
      'source' => { 'pointer' => '/data/attributes/password' },
      'title' => 'Invalid login or password',
      'detail' => 'You must provide valid credentials in order to exchange it for token.'
    }
  end

  it 'should return 401 status code' do
    subject

    expect(response).to have_http_status 401
  end

  it 'should return proper json body' do
    subject

    expect(json['errors']).to include(authorization_error)
  end
end

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
    expect(json['errors']).to include(authorization_error)
  end
end
