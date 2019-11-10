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
      articles = create_list :article, 2

      subject

      articles.each_with_index do |article, index|
        expect(json_data[index]['attributes']).to eq(
          'title' => article.title,
          'content' => article.content,
          'slug' => article.slug
        )
      end
    end
  end
end
