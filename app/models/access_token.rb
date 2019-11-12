# frozen_string_literal: true

class AccessToken < ApplicationRecord
  belongs_to :user
  after_initialize :generate_token

  validates :token, presence: true

  private

  def generate_token
    # 一意な文字列を生成するにはどうすれば良いか。
    self.token = SecureRandom.hex(10)
  end
end
