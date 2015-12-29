class ControlController < ApplicationController

def index
	if params[:isvalid]
		session[:current_user] = 1
	else
		redirect_to root_path
	end
	if params[:search]
      @users = User.search(params[:search])
    end
    #@medication = Medication.new(:userid => 1, :name => "Concerta", :schedule => "daily", :dose => "5 mg", :datapoints => [[Date.new(2015,11,29), "true"]])
   # @medication.save
end

def setviewuser
	key = Rails.application.secrets.secret_key_base
	encrypt = ActiveSupport::MessageEncryptor.new(key)
	view = encrypt.decrypt_and_verify(params[:viewuser])
	session[:viewuser] = view
	redirect_to dashboard_index_path
end

def createuser
	@user = User.new(:firstname => params[:firstname].capitalize, :lastname => params[:lastname].capitalize, :organization => current_org.selfid, :active => true, :fullname => "#{params[:firstname].capitalize} #{params[:lastname].capitalize}", :role => params[:role])
	key = Rails.application.secrets.secret_key_base
	encrypt = ActiveSupport::MessageEncryptor.new(key)
	@user.encryptedpassw = encrypted_data = encrypt.encrypt_and_sign(params[:encryptedpassw])
	@user.save
	redirect_to control_index_path
end

def encrypt(value)
	key = Rails.application.secrets.secret_key_base
	encrypt = ActiveSupport::MessageEncryptor.new(key)
	en = encrypt.encrypt_and_sign(value)
	return en
end
helper_method :encrypt
private

def user_params
	params.require(:user).permit(:firstname, :lastname, :organization, :role)
end

end
