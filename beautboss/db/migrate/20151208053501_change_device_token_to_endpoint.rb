class ChangeDeviceTokenToEndpoint < ActiveRecord::Migration
  change_table :devices do |t|
    t.rename :device_token, :endpoint
    t.rename :device_type, :type
  end
end
