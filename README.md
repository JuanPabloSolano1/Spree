# README
Coqtail Technical assignment

Tasks
1. The client wants a way to export the product data in XML format
Create an endpoint that returns:
- all products
- products updated in the last 24 hours.

Solution: 
Routes for two different endpoints 
1) products/export/all
2) product/export/recent

``` Ruby
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
```

Export Views
![image](https://github.com/JuanPabloSolano1/Spree/blob/master/Screenshot%202019-10-28%2020.03.26.png)
![image](https://github.com/JuanPabloSolano1/Spree/blob/master/Screenshot%202019-10-28%2020.01.37.png)

Export Controller
``` Ruby

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

```
Upload and parse XML file. POST the request into the products API.
```Javascript
let fileInput = document.getElementById('fileInput');
  let fileDisplayArea = document.getElementById('fileDisplayArea');
fileInput.addEventListener('change', function (e) {
    event.preventDefault()
        var file = fileInput.files[0];
        var textType = /text.*/;

        if (file.type.match(textType)) {
            var reader = new FileReader();

            reader.onload = function (e) {
               let readXml = e.target.result
               let parser = new DOMParser();
               let doc = parser.parseFromString(readXml, "text/xml");

    let submit = document.getElementById("submit")
    submit.addEventListener("click",(event)=>{
    event.preventDefault()
    let name_1 = doc.getElementsByTagName("name")[0].childNodes[0].nodeValue;
    let price_1 = doc.getElementsByTagName("price")[0].childNodes[0].nodeValue;
    let description_1 = doc.getElementsByTagName("description")[0].childNodes[0].nodeValue;
    let shipping_1 = 1
    fetch("http://localhost:3000/api/v1/products", {
    body: `product[name]=${name_1}&product[price]=${parseInt(price_1)}&product[shipping_category_id]=${(shipping_1)}&product[description]=${description_1}`,
     headers: {
     "Content-Type": "application/x-www-form-urlencoded",
     "X-Spree-Token": ""
     },
     method: "POST"
   })
            })
    }

            reader.readAsText(file);
        } else {
            xmlFileInfo.innerText = "File not supported!"
        }
  });

```
![image](https://github.com/JuanPabloSolano1/Spree/blob/master/Screenshot%202019-10-28%2020.10.22.png)
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<object>
    <id type="integer">44</id>
    <name>Spree-Card-Juan-Final-Erika</name>
    <description>Perfect Product</description>
    <price type="decimal">2.0</price>
    <taxons type="array"/>
    <variants type="array"/>
</object>

```
