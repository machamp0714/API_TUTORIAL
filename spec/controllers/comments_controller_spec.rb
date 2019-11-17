# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:article) { create :article }

  describe "GET #index" do
    subject { get :index, params: { article_id: article.id } }

    it "returns a success response" do
      subject
      expect(response).to have_http_status :ok
    end

    it 'return comments belonging to the article' do
      comment = create :comment, article: article
      create :comment

      subject
      expect(json_data.length).to eq(1)
      expect(json_data.first['id']).to eq(comment.id.to_s)
    end

    it 'should paginate results' do
      comments = create_list :comment, 3, article: article
      get :index, params: { article_id: article.id, per_page: 1, page: 2 }

      expect(json_data.length).to eq(1)
      comment = comments.second
      expect(json_data.first['id']).to eq(comment.id.to_s)
    end

    it 'return proper json body' do
      comment = create :comment, article: article
      subject

      expect(json_data.first['attributes']).to eq(
        'content' => comment.content
      )
    end

    it 'return relationships with aritcle and user' do
      user = create :user
      create :comment, article: article, user: user
      subject

      relationships = json_data.first['relationships']

      expect(relationships['article']['data']['id']).to eq(article.id.to_s)
      expect(relationships['user']['data']['id']).to eq(user.id.to_s)
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
