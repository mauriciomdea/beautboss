class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :user, index: true
      t.belongs_to :sender, index: true
      t.text :message
      t.timestamps null: false
    end
  end
end
