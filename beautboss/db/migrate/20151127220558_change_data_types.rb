class ChangeDataTypes < ActiveRecord::Migration
  def change
    change_column :comments, :comment, :text
    change_column :users, :bio, :text
    change_column :users, :avatar, :text
  end
end
