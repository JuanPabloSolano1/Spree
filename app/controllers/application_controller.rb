class ApplicationController < ActionController::Base
  before_action :authenticate_spree_user!
  def index
     user = Spree::user_class.first
     api_key = user.spree_api_key
  end
end
