class User < ActiveRecord::Base
	has_secure_password
	before_create :set_auth_token
	def self.search(search)
   		where("fullname LIKE ?", "%#{search.split(" ").map(&:capitalize).join(" ")}%") 
	end

    def self.medifications
        @users_to_alert = {}
        @time = Time.now.localtime.hour.to_i % 12
        merid = "am"
        if Time.now.localtime.hour.to_i >= 12
            merid = "pm"
        end
        Medication.all.each do |m|
            notif = ApplicationController.helpers.decrypt(m.notification_time)
            if notif.split(' ')[0].to_i == @time && notif.split(' ')[1] == merid

            	shouldtake = false

                frequency = ApplicationController.helpers.decrypt(m.schedule)
                timestamp = m.created_at.localtime
            	createadate = Date.strptime("#{timestamp.month}/#{timestamp.day}/#{timestamp.year}", '%m/%d/%Y')
            	dayssinceadd = Date.today - createadate

            	if frequency == "daily" && createadate <= Date.today
            	    shouldtake = true
            	elsif frequency == "weekly" && createadate <= Date.today && dayssinceadd % 7 == 0
            	    shouldtake = true
            	elsif frequency != "daily" && frequency != "weekly" && createadate <= Date.today

            	    timecount = frequency.split(" times/")[0].to_i
            	    timeunit = frequency.split(" times/")[1]

            	    if timeunit == "day" && createadate <= Date.today
            	        shouldtake = true
            	    end

            	    if timeunit == "week" && createadate <= Date.today
            	        @daystopushweek = []
            	        weektimeblock = 7.0 / timecount
            	        g = 0
            	        timecount.times do
            	            g += 1
            	            @daystopushweek.push (weektimeblock * g)
            	        end
            	        @daystopushweek.map! {|item| item.round}
            	        @daystopushweek.each do |numb|
            	            if (numb + createadate.strftime("%w").to_i) > 7
            	                newnumb = numb + createadate.strftime("%w").to_i - 7
            	            else
            	                newnumb = numb + createadate.strftime("%w").to_i
            	            end
            	            if Date.today.strftime("%u").to_i == newnumb
            	                shouldtake = true
            	            end
            	        end
            	    end

            	    if timeunit == "month" && createadate <= Date.today
            	        @daystopushmonth = []
            	        monthtimeblock = Time.now.end_of_month.day.to_f / timecount
            	        g = 0
            	        timecount.times do
            	            g += 1
            	            @daystopushmonth.push (monthtimeblock * g)
            	        end
            	        @daystopushmonth.map! {|item| item.round}
            	        @daystopushmonth.each do |numb|
            	            if Date.today.day.to_i == numb
            	                shouldtake = true
            	            end
            	        end
            	    end

                end

                if shouldtake
                	uid = ApplicationController.helpers.decrypt(m.userid).to_s
                	if @users_to_alert.has_key?(uid)
                	    @users_to_alert[uid] = @users_to_alert[uid].push m.id
                	else
                	    @users_to_alert[uid] = [m.id]
                	end
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
