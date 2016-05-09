class AddLanguageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :language, :string, :default => "en-US"
  end
end
