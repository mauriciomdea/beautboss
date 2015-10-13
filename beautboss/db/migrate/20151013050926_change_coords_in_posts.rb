class ChangeCoordsInPosts < ActiveRecord::Migration
  change_table :posts do |t|
    t.rename :lat, :latitude
    t.rename :lon, :longitude
  end
end
