# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.string :name

      t.timestamps
    end
    add_reference :tags, :article, foreign_key: true
  end
end
