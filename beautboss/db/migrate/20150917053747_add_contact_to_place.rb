class AddContactToPlace < ActiveRecord::Migration
  def change
    add_column :places, :contact, :string
  end
end
