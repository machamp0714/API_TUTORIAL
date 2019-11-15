# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:article) { create :article }

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: { article_id: article.id }
      expect(response).to have_http_status :ok
    end
  end

  describe "POST #create" do
    let(:valid_attributes) { { content: 'My awesome comment for article' } }
    let(:invalid_attributes) { { content: '' } }

    context 'when no authorized' do
      subject { post :create, params: { article_id: article.id, comment: valid_attributes } }

      context 'when no authorization headers provided' do
        it_behaves_like 'forbidden_request'
      end

      context 'when invalid authorization provided' do
        before { request.headers['authorization'] = 'invalid_token' }
        it_behaves_like 'forbidden_request'
      end
    end

    context 'when authorized' do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context "with valid params" do
        subject { post :create, params: { article_id: article.id, comment: valid_attributes } }

        it "creates a new Comment" do
          expect do
            subject
          end.to change(Comment, :count).by(1)
        end

        it "renders a JSON response with the new comment" do
          subject
          expect(response).to have_http_status(:created)
          expect(response.location).to eq(article_url(article))
        end

        it 'should return proper json body' do
          subject
          expect(json_data['attributes']).to include(
            'content' => 'My awesome comment for article',
            'user_id' => user.id,
            'article_id' => article.id
          )
        end
      end

      context "with invalid params" do
        it "renders a JSON response with errors for the new comment" do
          post :create, params: { article_id: article.id, comment: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end
end
