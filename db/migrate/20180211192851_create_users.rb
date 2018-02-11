class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :email
      t.string :username
      t.text :bio
      t.string :image
      t.string :password
      t.integer :followers_count
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
