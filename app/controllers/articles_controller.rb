# frozen_string_literal: true

class ArticlesController < ApplicationController
  def index
    articles = Article.recent.page(params[:page]).per(params[:per_page])
    render json: articles
  end

  def show
    article = Article.find(params[:id])
    render json: article, status: :ok
  end
end
