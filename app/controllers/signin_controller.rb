class SigninController < ApplicationController
  def index
  	#if session[:current_user]
  	#	redirect_to root_path
  	#end
  end
  def signin
    found = false
    user = []
  	User.all.each do |us|
      user.push us unless decrypt(us.fullname) != params[:username]
    end
  	user.each do |u|
  		if u.authenticate(params[:password])
  			session[:current_user] = u.id
  			found = true
  		end
  	end
  	if found == false
  		redirect_to root_path
  	else
  		redirect_to control_index_path
  	end
  end

  def register
  end

  def registerpost
    found = false
    user = []
    User.all.each do |us|
      user.push us unless decrypt(us.fullname) != params[:username]
    end
    user.each do |u|
      if u.accesscode == params[:access]
        session[:current_user] = u.id
        found = true
        User.update(u.id, :password => params[:password], :accesscode => nil, :active => "true")       
      end
    end
    if found == false
      redirect_to root_path
    else
      redirect_to control_index_path
    end
  end
end
