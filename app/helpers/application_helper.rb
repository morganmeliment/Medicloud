module ApplicationHelper
	  def current_user
    	if session[:current_user].present?
    	  return @current_user ||= User.find(session[:current_user])
      else
        return false
      end
  	end

  	def current_org
  		return unless session[:current_user]
  		@org ||= Organization.where(:selfid => decrypt(current_user.organization)).first()
  	end

    def viewuser
      return unless session[:viewuser]
      @viewuser ||= User.find(session[:viewuser])
    end

    def encrypt(value)
      key = Rails.application.secrets.secret_key_base
      encrypt = ActiveSupport::MessageEncryptor.new(key)
      en = encrypt.encrypt_and_sign(value)
      return en
    end

    def decrypt(value2)
      keys = Rails.application.secrets.secret_key_base
      decrypt = ActiveSupport::MessageEncryptor.new(keys)
      de = decrypt.decrypt_and_verify(value2)
      return de
    end

end
