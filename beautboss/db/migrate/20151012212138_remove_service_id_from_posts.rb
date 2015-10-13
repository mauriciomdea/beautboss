class RemoveServiceIdFromPosts < ActiveRecord::Migration
  change_table :posts do |t|
    t.remove :service_id
  end
end
