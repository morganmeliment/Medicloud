class HomepageController < ApplicationController
  def index
  end
  def signout
  	session.delete(:current_user)
  	redirect_to root_path
  end
end
