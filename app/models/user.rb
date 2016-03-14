class User < ActiveRecord::Base
	has_secure_password
	before_create :set_auth_token
	def self.search(search)
   		where("fullname LIKE ?", "%#{search.split(" ").map(&:capitalize).join(" ")}%") 
	end

    def self.medifications
        @users_to_alert = {}
        @time = Time.now.localtime.hour.to_i % 12
        if Time.now.localtime.hour.to_i >= 12
            merid = "pm"
        else
            merid = "am"
        end
        Medication.all.each do |m|
            notif = ApplicationController.helpers.decrypt(m.notification_time)
            if notif.split(' ')[0].to_i == @time && notif.split(' ')[1] == merid
                uid = ApplicationController.helpers.decrypt(m.userid).to_s
                if @users_to_alert.has_key?(uid)
                    @users_to_alert[uid] = @users_to_alert[uid].push m.id
                else
                    @users_to_alert[uid] = [m.id]
                end
            end
        end
        @users_to_alert.each do |t|
            if t[1].length >= 3
                User.find(t[0]).deviceids.each do |devid|
                    APNS.send_notification(devid, :alert => "You have #{t[1].length} medications to take.", :message => "hello")
                end
            else
                User.find(t[0]).deviceids.each do |devid|
                    itr = 0
                    t[1].length.times do
                        APNS.send_notification(devid, :alert => "You have to take #{ApplicationController.helpers.decrypt(Medication.find(t[1][itr]).name)}.", :message => "hello")
                        itr += 1
                    end
                end
            end
        end
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
