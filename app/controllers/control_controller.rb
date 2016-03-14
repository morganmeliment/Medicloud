class ControlController < ApplicationController
require "bcrypt"
require "erb"
require 'open-uri'
include ERB::Util

def index
	if !session[:current_user].present?
		flash[:notice] = "You are not signed in."
		redirect_to root_path
	else
		if !current_user.active
			flash[:notice] = "This account is no longer active."
			redirect_to root_path
		end
		if !current_user.accesscode.nil?
			flash[:notice] = "You need to register first."
			redirect_to root_path
		end
		if decrypt(current_user.role) == "patient"
			redirect_to "https://itunes.apple.com/us/app/medicloud/id972694931?mt=8"
		end
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
   					if u.active && decrypt(u.role) == "patient"
    					@users.push u
    				end
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
	if params[:last].present? and params[:first].present? and ["admin", "physician", "patient"].include? params[:type]
		@code = rand(36**12).to_s(36)
		@user = User.new(:firstname => encrypt(params[:first].capitalize), :lastname => encrypt(params[:last].capitalize), :organization => encrypt(current_org.selfid), :active => false, :fullname => encrypt("#{params[:first].capitalize} #{params[:last].capitalize}"), :role => encrypt(params[:type]), :accesscode => @code, :password => "nil")
		@user.save!
		File.open('information.pdf', 'wb') do |fo|
  			fo.write open("http://www.spurdoc.com/api/make?url=" + url_encode("http://medicloud.io/control/generatesignup?org=#{current_org.name.split(' ').join('_')}&name=#{params[:first].capitalize}_#{params[:last].capitalize}&code=#{@code}")).read
  			send_data open(fo).read.force_encoding('BINARY'), :filename => "#{params[:first].capitalize} #{params[:last].capitalize}", :type => "application/pdf", :disposition => 'inline'
		end
	else
		flash[:notice] = "Invalid user."
		redirect_to control_index_path
	end
end

end
