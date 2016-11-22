Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  namespace :api do
    namespace :v1 do

      resources :users, except: [:new, :edit] do
        member do
          get 'posts'  => 'users#posts'  
          post 'follow' => 'followers#create'
          delete 'follow' => 'followers#destroy'
          get :following, :followers
          get :notifications
          get 'friends'  => 'users#friends'
          post 'devices' => 'devices#create'
          delete 'devices' => 'devices#destroy'
          get 'blocked' => 'blocked#index'
          post 'block' => 'blocked#create'
          delete 'block' => 'blocked#destroy'
          get 'conversations/:id' => 'conversations#index'
        end
        resources :messages #, only: [:index, :create, :update, :destroy]
      end

      resources :authentications, only: [:create, :destroy]
      post 'authentications/facebook' => 'authentications#create_from_facebook', as: :authentications_facebook
      post 'authentications/password_reset' => 'authentications#password_reset', as: :password_reset

      resources :posts, except: [:new, :edit] do 
        # resources :wows, only: [:index, :create, :destroy]
        member do 
          get 'wows'  => 'wows#index'  
          post 'wows' => 'wows#create'
          delete 'wows' => 'wows#destroy'
        end
        resources :comments, only: [:index, :create, :destroy]
        resources :reports, only: [:create]
      end

      resources :places, only: [:index, :show] do 
        member do 
          get 'posts'  => 'places#posts'
        end
      end

      get 'newsfeed/all'  => 'newsfeed#all'
      get 'newsfeed/registers'  => 'newsfeed#registers'

    end
  end

  root 'site#index'

  get '/about' => 'site#about', as: :about
  get '/support' => 'site#support', as: :support
  get '/privacy_policies' => 'site#privacy', as: :privacy
  get '/terms_of_use' => 'site#terms', as: :terms
  get '/sign-in' => 'authentications#index', as: :sign_in
  get '/sign-in/facebook' => 'authentications#facebook', as: :sign_in_facebook
  get '/sign-out' => 'authentications#destroy', as: :sign_out

  resources :authentications, only: [:create, :destroy]

  get '/forgot_password' => 'passwords#new', as: :forgot_password
  post '/forgot_password' => 'passwords#create', as: :new_password
  # get '/password_reset' => 'authentications#password_reset', as: :password_reset

  resources :wows, only: [:create, :destroy]

  resources :comments, only: [:create]

  # resources :newsfeeds
  get '/registers/:id' => 'newsfeed#show', as: :register
  get '/:username/newsfeed' => 'newsfeed#index', as: :newsfeed

  get '/:username' => 'users#show', as: :user
  get '/:username/edit' => 'users#edit', as: :edit_user
  put '/:username' => 'users#update'
  delete '/:username' => 'users#destroy'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
