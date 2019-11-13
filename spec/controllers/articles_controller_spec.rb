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
end
