class AddServiceToPost < ActiveRecord::Migration
  def change
    add_column :posts, :service_id, :integer, index: true
  end
end
