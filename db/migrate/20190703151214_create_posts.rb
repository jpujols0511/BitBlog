class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :content
      t.string :image_url
      t.string :created_by
      t.integer :user_id
      t.datetime :created_at
    end
  end
end
