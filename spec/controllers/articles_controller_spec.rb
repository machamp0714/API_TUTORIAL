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
  end
end
