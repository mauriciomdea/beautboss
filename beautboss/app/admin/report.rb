ActiveAdmin.register Report, as: "Report" do 
  # actions :index, :show, :new, :create, :update, :edit
  actions :index, :show, :destroy

  config.paginate = true
  config.per_page = 25

  permit_params :post, :user, :flag

  # scope :innapropriate, where(flag: 0)

  filter :user_name_cont, label: 'User'
  filter :flag, as: :select, collection: Report.flags
  filter :created_at
  filter :updated_at

  index do
    column :image do |report|
      link_to image_tag(report.post.image, size: '64x64'), admin_register_path(report.post)
    end
    column :flag
    column :explanation
    column :reporter do |report|
      link_to report.user.name, admin_user_path(report.user)
    end
    column :created_at do |report| 
      l report.created_at, format: :custom
    end
    column :updated_at do |report| 
      l report.updated_at, format: :custom
    end
  end

end