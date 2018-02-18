# frozen_string_literal: true

class AddIndexToFavorites < ActiveRecord::Migration[5.2]
  def change
    add_index :favorites, %i[article_id user_id], unique: true
  end
end
