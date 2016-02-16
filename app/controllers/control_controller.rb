class ControlController < ApplicationController
require "bcrypt"
def index
	if !session[:current_user].present?
		redirect_to root_path
	end
	#if params[:isvalid]
	#	session[:current_user] = 1
	#else
	#	redirect_to root_path
	#end
	#session[:current_user] = 5
	#session[:org] = current_org.selfid
	if params[:search].present?
    	@users = []
    	User.all.each do |u|
    		if decrypt(u.organization) == decrypt(current_user.organization)
    			if decrypt(u.fullname).include? params[:search]
    				@users.push u
    			end
    		end
    	end
    end
=begin		
 	end
 	?org=#{current_org.name.split(' ').join('_')}&name=#{params[:first].capitalize}_#{params[:last].capitalize}&code=#{@code}
    @medication = Medication.new(:userid => 1, :name => "Concerta", :schedule => "daily", :dose => "5 mg", :datapoints => [[Date.new(2015,11,29), "true"]])
    @medication.save
=end
end

def setviewuser
	session[:viewuser] = decrypt(params[:viewuser])
	redirect_to dashboard_index_path
end

def generatesignup
end

def newuser
	@code = rand(36**12).to_s(36)
	@user = User.new(:firstname => encrypt(params[:first].capitalize), :lastname => encrypt(params[:last].capitalize), :organization => encrypt(current_org.selfid), :active => false, :fullname => encrypt("#{params[:first].capitalize} #{params[:last].capitalize}"), :role => encrypt(params[:type]), :accesscode => @code, :password => "nil")
	@user.save!
	redirect_to "/control/generatesignup.pdf?org=#{current_org.name.split(' ').join('_')}&name=#{params[:first].capitalize}_#{params[:last].capitalize}&code=#{@code}"
end

end
