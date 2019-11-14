# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe '#index' do
    subject { get :index }

    it 'index should return success response' do
      subject
      expect(response).to have_http_status :ok
    end

    it 'index should return json data' do
      create_list :article, 2

      subject

      Article.recent.each_with_index do |article, index|
        expect(json_data[index]['attributes']).to eq(
          'title' => article.title,
          'content' => article.content,
          'slug' => article.slug
        )
      end
    end

    it 'returns a article list in order by' do
      old_article = create :article
      new_article = create :article
      subject

      expect(json_data.first['id']).to eq new_article.id.to_s
      expect(json_data.last['id']).to eq old_article.id.to_s
    end

    it 'should paginate results' do
      create_list :article, 3
      get :index, params: { page: 2, per_page: 1 }

      expect(json_data.length).to eq 1
      expect(json_data.first['id']).to eq Article.recent.second.id.to_s
    end
  end

  describe 'GET #show' do
    let(:article) { create :article }
    let(:article_data) do
      {
        'title' => article.title,
        'content' => article.content,
        'slug' => article.slug
      }
    end
    subject { get :show, params: { id: article.id } }

    it 'should return 200 status code' do
      subject
      expect(response).to have_http_status :ok
    end

    it 'should return proper json' do
      subject
      expect(json_data['attributes']).to eq(article_data)
    end
  end

  describe 'POST #create' do
    let(:invalid_attributes) do
      {
        data: {
          attributes: {
            title: '',
            content: ''
          }
        }
      }
    end

    subject { post :create, params: invalid_attributes }

    context 'when no authorization headers provided' do
      it_behaves_like 'forbidden_request'
    end

    context 'when invalid authorization provided' do
      before { request.headers['authorization'] = 'Invalid token' }
      it_behaves_like 'forbidden_request'
    end

    context 'when authorized' do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context 'when invalid parameters provided' do
        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'should return proper json' do
          subject
          expect(json['errors']).to include(
            {
              "source" => { "pointer" => "/data/attributes/title" },
              "detail" => "can't be blank"
            },
            {
              "source" => { "pointer" => "/data/attributes/content" },
              "detail" => "can't be blank"
            },
            {
              "source" => { "pointer" => "/data/attributes/slug" },
              "detail" => "can't be blank"
            }
          )
        end
      end

      context 'when success request sent' do
        let(:valid_attributes) do
          {
            'data' => {
              'attributes' => {
                'title' => 'It is title.',
                'content' => 'Super content!',
                'slug' => 'slug-article'
              }
            }
          }
        end
        subject { post :create, params: valid_attributes }

        it 'should return 201 status code' do
          subject
          expect(response).to have_http_status :created
        end

        it 'should return proper json body' do
          subject
          expect(json_data).to include(valid_attributes['data'])
        end

        it 'shoud create article' do
          expect { subject }.to change { Article.count }.by(1)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:article) { create :article }
    let(:invalid_attributes) do
      {
        'id' => article.id,
        'data' => {
          'attributes' => {
            'title' => '',
            'content' => '',
            'slug' => ''
          }
        }
      }
    end
    subject { patch :update, params: invalid_attributes }

    context 'when no authorization headers provided' do
      it_behaves_like 'forbidden_request'
    end

    context 'when invalid authorization provided' do
      before { request.headers['authorization'] = 'invalid_token' }
      it_behaves_like 'forbidden_request'
    end

    context 'when authorized' do
      let(:user) { create :user }
      let(:access_token) { user.create_access_token }
      before { request.headers['authorization'] = "Bearer #{access_token.token}" }

      context 'when invalid parameters provided' do
        it 'should return 422 status code' do
          subject
          expect(response).to have_http_status :unprocessable_entity
        end

        it 'should return proper error json' do
          subject
          expect(json['errors']).to include(
            {
              "source" => { "pointer" => "/data/attributes/title" },
              "detail" => "can't be blank"
            },
            {
              "source" => { "pointer" => "/data/attributes/content" },
              "detail" => "can't be blank"
            },
            {
              "source" => { "pointer" => "/data/attributes/slug" },
              "detail" => "can't be blank"
            }
          )
        end
      end
    end
  end
end
