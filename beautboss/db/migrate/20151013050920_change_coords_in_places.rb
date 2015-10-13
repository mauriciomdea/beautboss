class ChangeCoordsInPlaces < ActiveRecord::Migration
  change_table :places do |t|
    t.rename :lat, :latitude
    t.rename :lon, :longitude
  end
end
