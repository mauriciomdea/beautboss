class AddLocationToPlace < ActiveRecord::Migration
  def change
    add_column :places, :lat, :string
    add_column :places, :lon, :string
    add_column :places, :address, :string
  end
end
