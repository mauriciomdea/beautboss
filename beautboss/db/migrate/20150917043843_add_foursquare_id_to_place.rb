class AddFoursquareIdToPlace < ActiveRecord::Migration
  def change
    add_column :places, :foursquare_id, :string, index: true
  end
end
