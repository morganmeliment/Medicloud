class User < ActiveRecord::Base
	has_secure_password
	before_create :set_auth_token
	def self.search(search)
   		where("fullname LIKE ?", "%#{search.split(" ").map(&:capitalize).join(" ")}%") 
	end

	private

	def set_auth_token
    	return if auth_token.present?
    	self.auth_token = generate_auth_token
    end

    def generate_auth_token
    	SecureRandom.uuid.gsub(/\-/,'')
    end
end
