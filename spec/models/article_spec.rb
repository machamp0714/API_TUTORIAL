# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:article) { build(:article) }

  describe '#validations' do
    it 'モデルが有効な場合' do
      expect(article).to be_valid
    end

    it 'titleが空である場合' do
      article.title = ''
      expect(article).to be_invalid
      expect(article.errors.messages[:title]).to include("can't be blank")
    end

    it 'contentが空である場合' do
      article.content = ''
      expect(article).to be_invalid
      expect(article.errors.messages[:content]).to include("can't be blank")
    end

    it 'slugが空である場合' do
      article.slug = ''
      expect(article).to be_invalid
      expect(article.errors.messages[:slug]).to include("can't be blank")
    end

    it 'slugが一意ではない場合無効' do
      exist_article = create(:article)
      invalid_article = build :article, slug: exist_article.slug

      expect(invalid_article).to be_invalid
    end
  end

  describe 'recent' do
    it 'should list recent article first' do
      old_article = create :article
      new_article = create :article

      expect(described_class.recent).to eq(
        [new_article, old_article]
      )

      old_article.update_column :created_at, Time.now
      expect(described_class.recent).to eq(
        [old_article, new_article]
      )
    end
  end
end
