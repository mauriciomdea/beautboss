ActiveAdmin.register User do

  permit_params :name, :email, :password, :avatar, :website, :location, :bio, :notify_new_follower, :notify_new_comment, :notify_new_wow

  filter :name
  filter :email
  filter :location
  filter :created_at
  filter :updated_at

  index do
    column :id
    column :avatar do |user|
      image_tag user.avatar, size: '16x16'
    end
    column :name do |user| 
      link_to user.name, admin_user_path(user)
    end
    column :email
    column :website
    column :location
    # column :bio
    column :followers do |user| 
      user.followers.size
    end
    column :created_at
    column :updated_at
    actions
  end

end
