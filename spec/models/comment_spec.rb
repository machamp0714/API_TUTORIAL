# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe '#validations' do
    it 'should have valid content' do
      expect(build(:comment)).to be_valid
    end

    it 'should test presence of attributes' do
      comment = Comment.new
      expect(comment).to be_invalid
      expect(comment.errors.messages).to include(
        user: ['must exist'],
        article: ['must exist'],
        content: ["can't be blank"]
      )
    end
  end
end
