# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :authorize!, only: [:create]

  def index
    articles = Article.recent.page(params[:page]).per(params[:per_page])
    serializer = ArticleSerializer.new(articles).serialized_json
    render json: serializer
  end

  def show
    article = Article.find(params[:id])
    serializer = ArticleSerializer.new(article).serialized_json
    render json: serializer, status: :ok
  end

  def create
    article = Article.new(article_params)
    if article.valid?
      # create
    else
      error = ErrorSerializer.new(article).serialized_json
      render json: { errors: error }, status: :unprocessable_entity
    end
  end

  private

  def article_params
    # requireメソッドは何を返すの？
    # params.require(:data).require(:attributes).permit(:title, :content, :slug)
    ActionController::Parameters.new
  end
end
