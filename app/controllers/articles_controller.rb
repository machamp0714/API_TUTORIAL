# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index
    articles = Article.recent
    render json: articles
  end
end
