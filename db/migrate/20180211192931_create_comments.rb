class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.text :body
      t.references :user, foreign_key: true
      t.references :article, foreign_key: true

      t.timestamps
    end
  end
end
