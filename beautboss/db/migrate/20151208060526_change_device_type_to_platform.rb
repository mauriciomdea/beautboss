class ChangeDeviceTypeToPlatform < ActiveRecord::Migration
  change_table :devices do |t|
    t.rename :type, :platform
  end
end
