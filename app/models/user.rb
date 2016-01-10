class User < ActiveRecord::Base
	def self.search(search)
   		where("fullname LIKE ?", "%#{search.split(" ").map(&:capitalize).join(" ")}%") 
	end
	def medifications
		
	end
end
