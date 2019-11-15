# frozen_string_literal: true

class CommentSerializer
  include FastJsonapi::ObjectSerializer

  set_type :comments
  attributes :content, :user_id, :article_id
end
