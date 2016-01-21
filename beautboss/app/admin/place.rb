ActiveAdmin.register Place do

  config.paginate = true
  config.per_page = 25

  permit_params :place_id, :name

  filter :name
  filter :foursquare_id
  filter :created_at
  filter :updated_at

  index do
    column :id
    column :name
    column :latitude
    column :longitude
    column :posts do |place| 
      place.posts.size
    end
    column :created_at do |register| 
      l register.created_at, format: :custom
    end
    column :updated_at do |register| 
      l register.updated_at, format: :custom
    end
  end

end
