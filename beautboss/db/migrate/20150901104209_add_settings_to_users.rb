class AddSettingsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :instagram, :string
    add_column :users, :facebook, :string
    add_column :users, :swarm, :string
    add_column :users, :notify_new_follower, :boolean
    add_column :users, :notify_new_comment, :boolean
    add_column :users, :notify_new_wow, :boolean
  end
end
