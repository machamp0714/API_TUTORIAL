# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authorize!, only: %i[create]

  def index
    @comments = Comment.all

    render json: @comments
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
