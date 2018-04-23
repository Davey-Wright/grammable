class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.text :message
      t.integer :gram_id
      t.integer :user_id
      t.timestamps
    end
    add_index :comments, :gram_id
    add_index :comments, :user_id
  end
end
