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
    if article.save
      # create
    else
      error = {
        'status' => '422',
        'source' => { 'pointer' => '/data/attributes/title' },
        'title' => "can't be blank",
        'detail' => 'The title you provided cannot be blank.'
      }
      render json: { errors: [error] }, status: :unprocessable_entity
    end
  end

  private

  def article_params
    # requireメソッドは何を返すの？
    params.require(:data).require(:attributes).permit(:title, :content, :slug)
  end
end
