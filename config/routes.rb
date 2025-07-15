Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post '/login', to: 'authentication#login'
      delete '/logout', to: 'authentication#logout'
      
      namespace :admin do
        # Admin-only routes
        resources :users, only: [:index, :show, :create, :update, :destroy]
      end
      
      # User routes
      resources :documents # for your editor content
    end
  end
end