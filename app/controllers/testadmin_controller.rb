class TestadminController < ApplicationController
  def index
  	@user = User.new(:firstname => params[:firstname].capitalize, :lastname => params[:lastname].capitalize, :organization => params[:orgid], :active => true, :fullname => "#{params[:firstname].capitalize} #{params[:lastname].capitalize}", :role => params[:role])
  	key = Rails.application.secrets.secret_key_base
	encrypt = ActiveSupport::MessageEncryptor.new(key)
	@user.encryptedpassw = encrypted_data = encrypt.encrypt_and_sign(params[:passw])
	@user.save
	@org = Organization.new(:name => params[:orgname], :selfid => params[:orgid], :accounts => 1)
	@org.save
	#localhost:3000/testadmin/index?firstname=morgan&lastname=meliment&orgid=example&role=admin&passw=morgan&orgname=Example_Organization
  end
end
