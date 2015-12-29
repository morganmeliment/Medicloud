module ApplicationHelper
	  def current_user
    	return unless session[:current_user]
    	@current_user ||= User.find(session[:current_user])
  	end

  	def current_org
  		return unless session[:current_user]
  		@org ||= Organization.where(:selfid => current_user.organization).first()
  	end

    def viewuser
      return unless session[:viewuser]
      @viewuser ||= User.find(session[:viewuser])
    end

end
