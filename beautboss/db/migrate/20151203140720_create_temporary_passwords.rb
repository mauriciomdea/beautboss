class CreateTemporaryPasswords < ActiveRecord::Migration
  def change
    create_table :temporary_passwords do |t|
      t.belongs_to :user, index: true
      t.string :password
      t.date :expire_at
      t.timestamps null: false
    end
  end
end
