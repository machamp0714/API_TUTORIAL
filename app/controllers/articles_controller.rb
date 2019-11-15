# frozen_string_literal: true

class ArticlesController < ApplicationController
  before_action :authorize!, only: %i[create update]
  before_action :check_user, only: %i[update]

  def index
    articles = Article.recent.page(params[:page]).per(params[:per_page])
    serializer = ArticleSerializer.new(articles).serialized_json
    render json: serializer, status: :ok
  end

  def show
    article = Article.find(params[:id])
    serializer = ArticleSerializer.new(article).serialized_json
    render json: serializer, status: :ok
  end

  def create
    article = current_user.articles.build(article_params)
    if article.save
      serializer = ArticleSerializer.new(article).serialized_json
      render json: serializer, status: :created
    else
      error = ErrorSerializer.new(article).serialized_json
      render json: { errors: error }, status: :unprocessable_entity
    end
  end

  def update
    article = Article.find(params[:id])
    if article.update(article_params)
      serializer = ArticleSerializer.new(article).serialized_json
      render json: serializer, status: :ok
    else
      error = ErrorSerializer.new(article).serialized_json
      render json: { errors: error }, status: :unprocessable_entity
    end
  end

  private

  def article_params
    # params => <ActionController::Parameters {"data"=>{"type"=>"articles", "attributes"=>
    #  {"title"=>"", "content"=>"", "slug"=>""}}, "controller"=>"articles", "action"=>"create", "article"=>{}}
    #  permitted: false>
    params.require(:data).require(:attributes).permit(:title, :content, :slug)
  end

  def check_user
    article = Article.find(params[:id])
    raise AuthorizationError if current_user.id != article.user_id
  end
end
