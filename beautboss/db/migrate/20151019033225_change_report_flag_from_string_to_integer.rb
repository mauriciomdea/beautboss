class ChangeReportFlagFromStringToInteger < ActiveRecord::Migration
  def change
    change_column :reports, :flag, :integer
  end
end
