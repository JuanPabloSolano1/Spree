class ApplicationController < ActionController::Base
  respond_to :html, :xml, :json
  def index
   @user = Spree::user_class.first
   @api_key = @user.spree_api_key
   raise
  end
end
