class ChangeUsersBioFromStringToText < ActiveRecord::Migration
  def change
    change_column :users, :bio, :text
  end
end
