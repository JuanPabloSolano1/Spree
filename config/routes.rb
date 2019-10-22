Rails.application.routes.draw do
  mount Spree::Core::Engine, at: '/'
  Spree::Core::Engine.routes.draw do
    namespace :api, defaults: { format: 'xml' } do
      namespace :v1 do
        resources :products, only: [:index]
      end
    end
  end
end

