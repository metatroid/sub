Antisocial::Application.routes.draw do
	resource :session
	resource :authorizations
	resources :uploads
	resources :users do
		member do
			get :following, :followers
		end
	end
	resources :messages
	resources :questions
	resources :answers
	resources :posts, :only => [:create, :destroy]
	resources :relationships, :only => [:create, :destroy]
	resources :articles
	root :to => "pages#home"
	match '/contact', :to => 'pages#contact'
	match '/about', :to => 'pages#about'
	match '/help', :to => 'pages#help'
	match '/news', :to => 'pages#news'
	match '/logout', :to => 'sessions#destroy'
	match '/auth/:provider/callback', :to => 'sessions#create'
	match '/account', :to => 'users#show'
	match '/account/settings', :to => 'users#edit'
	match '/account/settings', :to => 'users#update'
	match '/auth/failure', :to => 'users#fail'
	match '/account/twpost', :to => 'users#post_twitter', :via => :post
	match '/account/fbpost', :to => 'users#post_facebook', :via => :post
	match '/account/upload', :to => 'users#upload', :via => :post
	match '/account/upload/fb', :to => 'users#upload_to_facebook', :via => :post
	match '/account/upload/tw', :to => 'users#upload_to_twitter', :via => :post
	match '/user/list', :to => 'users#index'
	match '/user/:id/profile' => 'users#profile', :as => :profile
	match '/user/:id/delete' => 'users#destroy', :as => :delete
	match '/posts/:id' => 'posts#destroy', :as => :delete_post
	match '/account/inbox' => 'users#inbox', :as => :inbox
	match '/account/update' => 'users#update_profile'
	match '/email' => 'pages#send_mail'
	match '/account/uploads' => 'users#uploads', :as => :uploads
	match '/account/layout' => 'users#layout', :as => :layouts
	match '/account/reset_layout' => 'users#reset_layout', :as => :reset_layouts, :via => :post
	match '/file/:id/:file_name', :to => 'uploads#show', :as => :file
	#match '/account/settings', :to => 'users#update', :conditions => { :method => :post }
	
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
