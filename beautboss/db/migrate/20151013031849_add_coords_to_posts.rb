class AddCoordsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :lat, :float
    add_column :posts, :lon, :float
  end
end
