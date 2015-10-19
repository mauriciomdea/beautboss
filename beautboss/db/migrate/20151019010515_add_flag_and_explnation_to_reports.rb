class AddFlagAndExplnationToReports < ActiveRecord::Migration
  def change
    add_column :reports, :flag, :string
    add_column :reports, :explanation, :string
  end
end
