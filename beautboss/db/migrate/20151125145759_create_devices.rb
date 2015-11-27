class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.belongs_to :user, index: true
      t.string :device_type
      t.text :device_token

      t.timestamps null: false
    end
  end
end
