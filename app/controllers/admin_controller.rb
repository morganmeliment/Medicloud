class AdminController < ApplicationController

	def index
		if params[:auth] == "MorganMeliment"
			flash[:notice] = "Welcome, Morgan!"
			@usercount = 0
			User.all.each do |u|
				@usercount += 1
			end
			@orgcount = 0
			Organization.all.each do |u|
				@orgcount += 1
			end

		else
			flash[:notice] = "You don't have access to that."
			redirect_to root_path
		end
	end

	def createorganization
		org = Organization.new(:name => params[:orgname], :selfid => params[:orgid])
		org.save
		flash[:notice] = "Organization Successfully Created!"
		redirect_to root_path
	end

	def createfirstuser
		if current_user
			if decrypt(current_user.fullname) == "Morgan Meliment" and params[:o].present?
				u = User.update(current_user.id, :organization => encrypt(params[:o]))
				u.save
			end
		else
			u = User.new(:firstname => encrypt("Morgan"), :lastname => encrypt("Meliment"), :active => true, :fullname => encrypt("Morgan Meliment"), :role => encrypt("superadmin"), :password => "uncle6307")
			u.save
		end
		redirect_to "/controlpanel?auth=MorganMeliment"
	end
end
