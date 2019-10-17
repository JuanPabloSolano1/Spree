class Api::V1::ProductsController < ApplicationsController
 def index
    @products = Spree::Product.all
    render xml: @products
  end
end
