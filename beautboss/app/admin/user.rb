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
    column :followers do |user| 
      user.followers.size
    end
    column :following do |user| 
      user.following.size
    end
    column :posts do |user| 
      user.posts.size
    end
    column :created_at
    column :updated_at
    actions
  end

  show title: :name do

    attributes_table do
      row :id
      row :name
      row :avatar do |user|
        image_tag user.avatar, size: '16x16'
      end
      row :email
      row :website
      row :location
      row :bio
      row :created_at do |register| 
        l register.created_at, format: :custom
      end
      row :updated_at do |register| 
        l register.updated_at, format: :custom
      end
    end

    panel "Posts" do
      table_for user.posts do
        column :id
        column :post do |post| 
          link_to post.service, admin_register_path(post)
        end
        column :created_at
      end
    end

  end

end
