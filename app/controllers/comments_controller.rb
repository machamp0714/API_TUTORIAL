# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authorize!, only: %i[create]

  def index
    @comments = Comment.all

    render json: @comments
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end
end
