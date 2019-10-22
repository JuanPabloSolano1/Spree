class Api::V1::ProductsController < Api::V1::BaseController
  def index
    @products = Spree::Product.all
     @products.each do |product|
       render xml: {
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price
        }
     end
  end
end
