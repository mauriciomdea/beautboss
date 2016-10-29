class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.belongs_to :user, index: true
      t.integer :troll_id, index: true
      t.timestamps null: false
    end
    add_index :blocks, [:user_id, :troll_id], unique: true
  end
end
