class MedDb < ActiveRecord::Base
	def self.search(search)
   		where("LOWER(name) LIKE ?", "%#{search}%")
	end
end
