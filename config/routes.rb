HuntBritain::Application.routes.draw do

  resources :users do 
	resources :hunts
	resources :purchases do
		resources :purchase_items
	end
  end
  
  resources :sessions, only: [:new, :create, :destroy]

  resources :locations do
	resources :products do
		resources :hunts
	end
  end

  resources :purchases do
	resources :purchase_items
  end
  
  resources :products 
  resources :hunts
	
  root to: 'marketing_pages#home'
  
  match 'accordion/:id', to: 'marketing_pages#accordion'
  match '/feedback', to: 'marketing_pages#feedback', via: :post
  match 'cart' => 'sessions#cart'
  match 'add_to_cart' => 'sessions#add_to_cart', :via => :post
  match 'remove_from_cart' => 'sessions#remove_from_cart', :via => :post
  match 'update_cart' => 'sessions#update_cart', :via => :put
  match 'checkout' => 'sessions#checkout'
  match 'hunt_login', to: 'hunts#hunt_login'
  match 'hunt_home/:id', to: 'hunts#hunt_home'
  match 'hunt_trail/:id', to: 'hunts#hunt_trail', :via => :post
  match 'change_voucher/:id', to: 'hunts#change_voucher'
  match 'restart_hunt/:id', to: 'hunts#restart_hunt'
   
  match '/faq', to: 'marketing_pages#faq'
  match '/print_settings', to: 'marketing_pages#print_settings'
  match '/about', to: 'marketing_pages#about'
  match '/contact', to: 'marketing_pages#contact'
  match '/copyright', to: 'marketing_pages#copyright'

  match '/signup', to: 'users#new'
  match '/editdetails', to: 'users#edit'
  match '/signin', to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  match '/identify', to: 'sessions#identify'
  match 'download', to: 'users#download'
  match 'reset_password', to: 'users#reset_password'
  
  match '/handle_payment', to: 'purchases#handle_payment'
  match 'paypal_notify', to: 'pay_pal#notify'
  match 'paypal_show', to: 'pay_pal#show'
  match 'paypal_notify_test', to: 'pay_pal#notify_test'
  
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
