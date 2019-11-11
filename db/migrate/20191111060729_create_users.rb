# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :login, null: false
      t.string :email
      t.string :avatar_url
      t.string :provider

      t.timestamps
    end
  end
end
