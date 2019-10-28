Rails.application.routes.draw do
mount Spree::Core::Engine, at: '/'
Spree::Core::Engine.add_routes do
    namespace :api, defaults: { format: 'json' } do
      namespace :v1 do
        namespace :products do
          resources :export, :all, only: [:index,:create,:new], :defaults => { :format => 'xml' }
        end
        get "/products/export/all/" => "products/export#index", :defaults => { :format => 'xml' }
        get "/products/export/recent/" => "products/export#recent", :defaults => { :format => 'xml' }
      end
    end
  end
end


