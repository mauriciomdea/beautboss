ActiveAdmin.register Post, as: "Register" do 
  # actions :index, :show, :new, :create, :update, :edit
  actions :index, :show, :destroy

  config.paginate = true
  config.per_page = 25

  permit_params :service, :image, :user_id, :place_id, :service_id, :category_id

  filter :user_name_cont, label: 'User'
  filter :place_name_cont, label: 'Place'
  filter :category, as: :select, collection: Post.categories
  filter :service
  filter :created_at
  filter :updated_at

  # index as: :grid, columns: 5 do |register|
  index do
    column :id
    column :image do |register|
      link_to image_tag(register.image, size: '64x64'), admin_register_path(register)
    end
    column :service
    column :user
    column :place
    column :category
    column :latitude
    column :longitude
    column :flags do |register| 
      register.reports.size
    end
    column :wows do |register| 
      register.wows.size
    end
    column :comments do |register| 
      register.comments.size
    end
    column :created_at do |register| 
      l register.created_at, format: :custom
    end
    column :updated_at do |register| 
      l register.updated_at, format: :custom
    end
  end

  show title: :service do

    attributes_table do
      row :id
      row :service
      row :image do |register|
        link_to register.image, register.image
      end
      row :user
      row :place
      row :category
      row :latitude
      row :longitude
      row :flags do |register| 
        register.reports.size
      end
      row :wows do |register| 
        register.wows.size
      end
      row :comments do |register| 
        register.comments.size
      end
      row :created_at do |register| 
        l register.created_at, format: :custom
      end
      row :updated_at do |register| 
        l register.updated_at, format: :custom
      end
    end

    panel "Comments" do
      table_for register.comments do
        column :id
        column :comment
        column :user
        column :created_at
      end
    end

    panel "Flags" do
      table_for register.reports do
        column :id
        column :flag do |report|
          report.flag.humanize
        end 
        column :explanation
        column :user
        column :created_at
      end
    end

  end

end
