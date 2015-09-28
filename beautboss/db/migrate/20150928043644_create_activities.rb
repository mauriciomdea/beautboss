class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      # t.integer :user_id
      t.belongs_to :user
      # t.integer :subject_id
      # t.string :subject_type
      t.belongs_to :subject, polymorphic: true
      t.boolean :read, default: false

      t.timestamps null: false
    end
    add_index :activities, [:user_id, :subject_id, :subject_type]
  end
end
