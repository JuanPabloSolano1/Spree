Rails.application.routes.draw do
  mount Spree::Core::Engine, at: '/'
  Spree::Core::Engine.routes.draw do
     namespace :api, defaults: { format: 'json' } do
      namespace :v1 do
        resources :products, only: [:index]
      end
    end
  end
end


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
