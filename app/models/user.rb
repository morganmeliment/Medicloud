class User < ActiveRecord::Base
	has_secure_password
	def self.search(search)
   		where("fullname LIKE ?", "%#{search.split(" ").map(&:capitalize).join(" ")}%") 
	end
end
