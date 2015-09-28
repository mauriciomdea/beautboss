class AddActorsToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :actor_id, :integer, index: true
  end
end
