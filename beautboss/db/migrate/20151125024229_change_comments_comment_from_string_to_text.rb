class ChangeCommentsCommentFromStringToText < ActiveRecord::Migration
  def change
    change_column :comments, :comment, :text
  end
end
