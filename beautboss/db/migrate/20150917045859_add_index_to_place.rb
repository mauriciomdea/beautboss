class AddIndexToPlace < ActiveRecord::Migration
  def change
    add_index :places, :foursquare_id
  end
end
