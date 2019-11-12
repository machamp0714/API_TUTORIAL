# frozen_string_literal: true

class AccessToken < ApplicationRecord
  belongs_to :user
  after_initialize :generate_token

  validates :token, presence: true

  private

  def generate_token
    # 一意な文字列を生成するにはどうすれば良いか。
    loop do
      # tokenは一度だけ生成する
      # tokenが存在する場合、tokenを生成しない
      # tokenが一意である時、tokenを生成しない
      break if token.present? && !AccessToken.where.not(id: id).exists?(token: token)

      self.token = SecureRandom.hex(10)
    end
  end
end
