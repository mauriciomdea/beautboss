class ChangeUserAvatarFromStringToText < ActiveRecord::Migration
  def change
    change_column :users, :avatar, :text
  end
end
