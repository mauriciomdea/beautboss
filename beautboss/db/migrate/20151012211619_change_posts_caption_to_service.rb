class ChangePostsCaptionToService < ActiveRecord::Migration
  change_table :posts do |t|
    t.rename :caption, :service
  end
end
