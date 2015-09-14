class AddPlaceToPost < ActiveRecord::Migration
  def change
    add_column :posts, :place_id, :integer, index: true
  end
end
