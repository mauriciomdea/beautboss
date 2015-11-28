class ChangePostsServiceCollation < ActiveRecord::Migration
  def change
    change_column :posts, :image, :text
    execute "ALTER TABLE posts CHANGE service service VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
  end
end
