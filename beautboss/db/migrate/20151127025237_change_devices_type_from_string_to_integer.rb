class ChangeDevicesTypeFromStringToInteger < ActiveRecord::Migration

  def change
    change_column :devices, :device_type, :integer
  end

end
