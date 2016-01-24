Rails.application.routes.draw do
  get 'notes/index'

  get 'medications/index'
  get 'medications/new'

  get 'testadmin/index'

  get 'dashboard/index'

  get 'control/setviewuser'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'homepage#index'

  get 'control/index'

  post '/createuser', to: 'control#createuser'

  get '/timelineapi', to: 'api#generatetimeline'
  get '/medapi', to: 'api#generatemeds'

  get '/dblist', to: 'api#createthedb'

  post '/createmedication', to: 'api#createmedication'
  post '/createnote', to: 'api#createnote'

  get '/registerdevice', to: 'api#registerdevice'
  get '/noti', to: 'api#sendnotification'
  get '/apinoteinfo', to: 'api#getnoteinfo'
  get '/generatenotes', to: 'api#generatenotes'
  get '/deletemedapi', to: 'api#deletemedapi'
  get '/deletenoteapi', to: 'api#deletenoteapi'

  get '/takemedicationapi', to: 'api#takemedicationapi'
  get '/getusername', to: 'api#getusername'
  get '/getnotei', to: 'api#getnotei'

  get '/completemedsearch', to: 'medications#completemedsearch'
  get '/getmedinfoweb', to: 'api#getmedinfoweb'
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
