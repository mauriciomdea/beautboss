class AddWowsCountToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :wows_count, :integer, default: 0
  end
end
