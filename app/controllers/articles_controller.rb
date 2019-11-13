# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :authorize!, only: [:create]

  def index
    articles = Article.recent.page(params[:page]).per(params[:per_page])
    render json: articles
  end

  def show
    article = Article.find(params[:id])
    render json: article, status: :ok
  end

  def create
    article = Article.new(article_params)
    if article.valid?
      # create
    else
      render json: article, adapter: :json_api,
             serializer: ActiveModel::Serializer::ErrorSerializer,
             status: :unprocessable_entity
    end
  end

  private

  def article_params
    # requireメソッドは何を返すの？
    # params.require(:data).require(:attributes).permit(:title, :content, :slug)
    ActionController::Parameters.new
  end
end
