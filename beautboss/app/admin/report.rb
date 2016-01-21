ActiveAdmin.register Report, as: "Report" do 
  # actions :index, :show, :new, :create, :update, :edit
  actions :index, :show, :destroy

  config.paginate = true
  config.per_page = 25

  permit_params :post, :user, :flag

  filter :user_name_cont, label: 'User'
  filter :flag
  filter :created_at
  filter :updated_at

  index do
    column :image do |register|
      link_to image_tag(register.image, size: '64x64'), admin_register_path(register)
    end
    column :flag
    column :user
    column :created_at do |register| 
      l register.created_at, format: :custom
    end
    column :updated_at do |register| 
      l register.updated_at, format: :custom
    end
  end

end