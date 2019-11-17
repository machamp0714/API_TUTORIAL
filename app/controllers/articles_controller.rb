# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :authorize!, only: %i[create update destroy]

  def index
    articles = Article.recent.page(params[:page]).per(params[:per_page])
    render json: articles, status: :ok
  end

  def show
    article = Article.find(params[:id])

    render json: article, status: :ok
  end

  def create
    article = current_user.articles.build(article_params)
    if article.save
      render json: article, status: :created
    else
      error = ErrorSerializer.new(article).serialized_json
      render json: { errors: error }, status: :unprocessable_entity
    end
  end

  def update
    article = current_user.articles.find(params[:id])
    article.update!(article_params)
    render json: article, status: :ok
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue StandardError
    error = ErrorSerializer.new(article).serialized_json
    render json: { errors: error }, status: :unprocessable_entity
  end

  def destroy
    article = current_user.articles.find(params[:id])
    article.destroy!
    head :no_content
  rescue StandardError
    authorization_error
  end

  private

  def article_params
    # params => <ActionController::Parameters {"data"=>{"type"=>"articles", "attributes"=>
    #  {"title"=>"", "content"=>"", "slug"=>""}}, "controller"=>"articles", "action"=>"create", "article"=>{}}
    #  permitted: false>
    params.require(:data).require(:attributes).permit(:title, :content, :slug)
  end
end
