# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authorize!, only: %i[create]

  def index
    article = Article.find(params[:article_id])
    comments = article.comments.page(params[:page]).per(params[:per_page])
    serializer = CommentSerializer.new(comments).serialized_json
    render json: serializer
  end

  def create
    article = Article.find(params[:article_id])
    comment = article.comments.build(comment_params.merge(user_id: current_user.id))

    if comment.save
      serializer = CommentSerializer.new(comment).serialized_json
      render json: serializer, status: :created, location: article
    else
      error = ErrorSerializer.new(comment).serialized_json
      render json: { errors: error }, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
