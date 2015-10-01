ActiveAdmin.register Post, as: "Register" do 

  permit_params :caption, :image, :user_id, :place_id, :service_id, :category_id

  filter :user_name_cont, label: 'User'
  filter :place_name_cont, label: 'Place'
  filter :category
  filter :service
  filter :created_at
  filter :updated_at

  # index as: :grid, columns: 5 do |register|
  index do
    column :id
    column :image do |register|
      link_to image_tag(register.image, size: '64x64'), admin_register_path(register)
    end
    column :caption
    column :user
    column :place
    column :category
    column :service
    column :wows do |register| 
      register.wows.size
    end
    column :created_at
    column :updated_at
  end

end
