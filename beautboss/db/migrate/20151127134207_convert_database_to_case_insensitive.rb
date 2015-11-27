class ConvertDatabaseToCaseInsensitive < ActiveRecord::Migration
  def change
    # for each table that will store unicode execute:
    # ALTER TABLE table_name CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    execute "ALTER TABLE comments CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
    execute "ALTER TABLE places CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
    execute "ALTER TABLE posts CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
    execute "ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
    # for each string/text column with unicode content execute:
    # ALTER TABLE table_name CHANGE column_name column_name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    execute "ALTER TABLE comments CHANGE comment comment VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
    execute "ALTER TABLE places CHANGE name name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
    execute "ALTER TABLE posts CHANGE service service VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
    execute "ALTER TABLE users CHANGE name name VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
    execute "ALTER TABLE users CHANGE bio bio VARCHAR(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
  end
end
