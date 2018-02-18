# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :slug
      t.string :title
      t.string :description
      t.text :body
      t.references :user, foreign_key: true
      t.integer :article_tag_count
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
    add_index :articles, :slug, unique: true
  end
end
