class ChangePlaceCoordsToFloat < ActiveRecord::Migration
  def change
    change_column :places, :lat, :float
    change_column :places, :lon, :float
  end
end
