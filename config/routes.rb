Rails.application.routes.draw do
  get '/users/sign_in', to: 'signin#index'
  get '/users/register', to: 'signin#register'
  post '/signin', to: 'signin#signin'
  post '/register', to: 'signin#registerpost'
  post '/addmed', to: 'medications#create'
  post '/medupdate', to: 'medications#update'
  post '/addnote', to: 'notes#create'
  post '/noteupdate', to: 'notes#update'
  get 'homepage/signout'
  get '/controlpanel', to: 'admin#index'
  get '/usermeddata', to: 'api#generatemedsswift'
  get '/usernotedata', to: 'api#generatenotesswift'
  get '/getmedinfoswift', to: 'api#getmedinfoswift'

  get '/getjsonmedinfo', to: 'api#getjsonmedinfo'

  post '/updatemedswift', to: 'api#updatemedswift'
  post '/updatenoteswift', to: 'api#updatenoteswift'

  get 'admin/createfirstuser'
  post 'admin/createorganization', to: 'admin#createorganization'

  get 'control/generatesignup'

  get 'notes/delete'
  get 'medications/checkforinteractions'

  get 'medications/delete'

  get 'notes/index'

  get 'medications/index'
  get 'medications/new'

  get 'testadmin/index'

  get 'dashboard/index'

  get 'control/setviewuser'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"remoteregistration
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
  get '/getnoteinfoweb', to: 'api#getnoteinfoweb'
  post '/user/new', to: 'control#newuser'
  get '/remotesignin', to: 'api#remotesignin'
  get '/remoteregistration', to: 'api#remoteregistration'
  post 'api/remoteregistration'
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
