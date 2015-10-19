class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.belongs_to :post, index: true
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
