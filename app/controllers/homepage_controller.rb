class HomepageController < ApplicationController
  def index
  end
  def signout
  	session.delete(:current_user)
  	flash[:notice] = "Signed out successfully!"
  	redirect_to root_path
  end
end
