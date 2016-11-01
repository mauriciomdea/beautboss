class AddStatusToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :read, :boolean, default: false
    add_column :messages, :blocked, :boolean, default: false
  end
end
