module Spree
  module Api
    module V1
      module Products
        class ExportController < Spree::Api::BaseController
          def index
            @products = product_scope
            expires_in 15.minutes, public: true

            headers['Surrogate-Control'] = "max-age=#{15.minutes}"
            respond_with(@products) do |format|
              format.xml { render xml: collect_data.to_xml }
            end
          end

          def new
            @product = product_scope.new
          end

          # def create
          #   uri = URI.parse("http://localhost:3000/api/v1/products")
          #   request = Net::HTTP::Post.new(uri)
          #   request["X-Spree-Token"] = "f10843e134b925f71ddc93eef7b5dbd3c2b69eba1831decc"
          #   request.set_form_data(
          #     "product[name]" => "Headphones1",
          #     "product[price]" => "100",
          #     "product[shipping_category_id]" => "1",
          #   )

          #   req_options = {
          #     use_ssl: uri.scheme == "https",
          #   }

          #   response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
          #     http.request(request)
          # end
          # end

          def collect_data
            products_hash = []
            @products.each do |product|
              products_hash << {
                id: product.id,
                name: product.name,
                description: product.description,
                price: product.price,
                taxons: collect_taxons(product),
                variants: collect_variants(product)
              }
            end
            products_hash
          end

          def collect_taxons(product)
            taxons_array = []
            product.taxons.each do |taxon|
              array_of_strings = []
              taxon.attributes.each do |attrib|
                array_of_strings << attrib[0] + ':' + ' ' + attrib[1].to_s
              end
              taxons_array << array_of_strings
            end
            taxons_array
          end

          def collect_variants(product)
            variants_array = []
            product.variants.each do |variant|
              array_of_strings = []
              variant.attributes.each do |attrib|
                array_of_strings << attrib[0] + ':' + ' ' + attrib[1].to_s
              end
              variants_array << array_of_strings
            end
            variants_array
          end

          def recent
            @products = product_scope
            now = Time.now
            @products = @products.where(updated_at: (now - 24.hours)..now)
            expires_in 15.minutes, public: true
            headers['Surrogate-Control'] = "max-age=#{15.minutes}"
            respond_with(@products) do |format|
              format.xml { render xml: collect_data.to_xml }
            end
          end
        end
      end
    end
  end
end
