class ApiController < ApplicationController
	skip_before_action :verify_authenticity_token
	require "open-uri"

def generateSchedule(usid, days)
  	@daystoconsider = days
  	# REWRITE THIS!!! MULTIPLE BUGS
  	# @medsfordays will be the days that the medication is supposed to be taken, 100% adherence
	@medsfordays = {}

	b = 0
	@daystoconsider.times do
		b += 1
		@medsfordays[b] = []
	end

	@usermeds = []
	Medication.all.each do |medication|
		if decrypt(medication.userid) == decrypt(usid)
			@usermeds.push medication
		end
	end

	# This calculates @medsfordays
	@usermeds.each do |medication|
		frequency = decrypt(medication.schedule)
		timestamp = medication.created_at.localtime
		int = @daystoconsider + 1
		(@daystoconsider).times do
			int -= 1
			datadate = Date.today + (int - 2).days
			createadate = Date.strptime("#{timestamp.month}/#{timestamp.day}/#{timestamp.year}", '%m/%d/%Y')
			dayssinceadd = datadate - createadate

			if dayssinceadd % 7 == 0
				weekly = true
			else
				weekly = false
			end

			if frequency == "daily" && createadate <= datadate
				@medsfordays[int].push medication.id
			elsif frequency == "weekly" && createadate <= datadate && weekly == true
				@medsfordays[int].push medication.id
			elsif frequency != "daily" && frequency != "weekly" && createadate <= datadate
				calcfreqone = frequency.split
				calcfreqtwo = calcfreqone[0].to_i
				calcfreqthree = calcfreqone[1].split("/")
				calcfreqfour = calcfreqthree[1]
				if calcfreqfour == "day" && createadate <= datadate
					calcfreqtwo.times do
						@medsfordays[int].push medication.id
					end
				end
				if calcfreqfour == "week" && createadate <= datadate
					@daystopushweek = []
					weektimeblock = 7.0 / calcfreqtwo
					g = 0
					calcfreqtwo.times do
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
						if datadate.strftime("%u").to_i == newnumb
							@medsfordays[int].push medication.id
						end
					end
				end
				if calcfreqfour == "month" && createadate <= datadate
					@daystopushmonth = []
					monthtimeblock = @daysinthismonth.to_f / calcfreqtwo
					g = 0
					calcfreqtwo.times do
						g += 1
						@daystopushmonth.push (monthtimeblock * g)
					end
					@daystopushmonth.map! {|item| item.round}
					@daystopushmonth.each do |numb|
						if datadate.day.to_i == numb
							@medsfordays[int].push medication.id
						end
					end
				end
			end
		end
	end

	return @medsfordays
end

def generate(usid, days)
	# Set @daystoconsider to the amount of days you want to include
  	@daystoconsider = days.to_i

  	# @medsfordays will be the days that the medication is supposed to be taken, 100% adherence
	@medsfordays = {}

	b = 0
	@daystoconsider.times do
		@medsfordays[b] = []
		b += 1
	end

	@usermeds = []
	Medication.all.each do |medication|
		if decrypt(medication.userid) == usid
			@usermeds.push medication
		end
	end
	# This calculates @medsfordays
	@usermeds.each do |medication|
			frequency = decrypt(medication.schedule)
			timestamp = medication.created_at.localtime
			int = -1
			@daystoconsider.times do
				int += 1
				datadate = Date.today - int.days
				createadate = Date.strptime("#{timestamp.month}/#{timestamp.day}/#{timestamp.year}", '%m/%d/%Y')
				dayssinceadd = datadate - createadate
				if dayssinceadd % 7 == 0
					weekly = true
				else
					weekly = false
				end

				if frequency == "daily" && createadate <= datadate
					@medsfordays[int].push medication.id
				elsif frequency == "weekly" && createadate <= datadate && weekly == true
					@medsfordays[int].push medication.id
				elsif frequency != "daily" && frequency != "weekly" && createadate <= datadate
					calcfreqone = frequency.split
					calcfreqtwo = calcfreqone[0].to_i
					calcfreqthree = calcfreqone[1].split("/")
					calcfreqfour = calcfreqthree[1]
					if calcfreqfour == "day" && createadate <= datadate
						calcfreqtwo.times do
							@medsfordays[int].push medication.id
						end
					end
					if calcfreqfour == "week" && createadate <= datadate
						@daystopushweek = []
						weektimeblock = 7.0 / calcfreqtwo
						g = 0
						calcfreqtwo.times do
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
							if datadate.strftime("%u").to_i == newnumb
								@medsfordays[int].push medication.id
							end
						end
					end
					if calcfreqfour == "month" && createadate <= datadate
						@daystopushmonth = []
						monthtimeblock = @daysinthismonth.to_f / calcfreqtwo
						g = 0
						calcfreqtwo.times do
							g += 1
							@daystopushmonth.push (monthtimeblock * g)
						end
						@daystopushmonth.map! {|item| item.round}
						@daystopushmonth.each do |numb|
							if datadate.day.to_i == numb
								@medsfordays[int].push medication.id
							end
						end
					end
				end
			end
	end
	return @medsfordays
end

def getusername
	render :text => decrypt(User.where(:auth_token => params[:io]).pluck(:firstname).first())
end

def generatetimeline
	#use a parameter to get user id in the future
	@userident = User.where(:auth_token => params[:auth]).pluck(:id).first()

	@schedule = generateSchedule(encrypt(@userident), 8)
	@timeline = {}

	@theuser = User.find(@userident)

	d = 0
	8.times do
		d += 1
		toDay = ""
		thisDate = Date.today + (d - 2).days
		if d == 1
			toDay = "Yesterday"
		elsif d == 2
			toDay = "Today"
		elsif d == 3
			toDay = "Tomorrow"
		else
			toDay = thisDate.strftime("%A")
		end

		todayMeds = []
		for x in @schedule[d]
			hasTaken = false
			thisMed = Medication.find(x)
			for g in thisMed.datapoints
				if g[0].to_date == thisDate && g[1] == "true"
					hasTaken = true
				end
			end
			todayMeds.append ["#{decrypt(thisMed.name)}, #{decrypt(thisMed.dose)}", hasTaken, thisMed.id]
		end
		@timeline[toDay] = todayMeds.sort {|a, b| a[2] <=> b[2]}
	end


	#turn data into html
	@fullhtml = ""
	i = 0
	for day in @timeline
		i += 1
		if i % 3 == 0
			dotcolor = "dot blue"
		elsif i % 3 == 1
			dotcolor = "dot red"
		else
			dotcolor = "dot green"
		end
		dateblock = "
		<div class = 'dateblock'>
        <div class = '" + dotcolor + "'></div>
        <p id = 'datetitle'>#{day[0]}</p>
		"
		for k in day[1]
			if i < 3
				if k[1] == true
            		snippet = "<div class = 'greenbutton'>
            				<span class = 'takeinfo' style = 'display: none;'>#{i - 2}, #{k[2]}</span>
                			<p class = 'whitetext'>Taken</p>
            			</div>"
            	else
            		snippet = "<div>
            				<span class = 'takeinfo' style = 'display: none;'>#{i - 2}, #{k[2]}</span>
                			<p>Take</p>
            			</div>"
            	end
				dateblock = dateblock + "
				<div class = 'medtakeblock'>
            		<p class = 'medname'>#{k[0]}</p>"+snippet+"</div>"
			else
				dateblock = dateblock + "
				<div class = 'medtakeblock'>
            		<p class = 'medname'>#{k[0]}</p>
        		</div>
				"
			end
		end
		if day[1] == []
			dateblock = dateblock + "
			<div class = 'medtakeblock'>
            	<p class = 'medname'>There aren't any medications on this day</p>
        	</div>"
		end
		@fullhtml = @fullhtml + dateblock + "</div>"
	end
	final = @fullhtml + '<br><br>' + "<div id = 'indent-line'></div>" + "
	<style>
	* {
    margin: 0px;
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    outline: none;
    -webkit-tap-highlight-color: rgba(0,0,0,0);
    -webkit-appearance: none;
}
*::-webkit-scrollbar { 
    display: none;
}
p {
    -webkit-font-smoothing: antialiased;
    font-family: -apple-system;
    font-weight: 300;
}
.dot {
    width: 11px;
    height: 11px;
    border-radius: 6px;
    margin-left: 20px;
    margin-top: 10px;
    position: relative;
    display: inline-block;
    margin-bottom: 4px;
    z-index: 4;
}
.red {
    background-color: red;
}
.dateblock {
    width: 100%;
    margin-top: 20px;
    position: relative;
}
#datetitle {
    display: inline-block;
    margin: 4px 0 0 15px;
    position: absolute;
    font-size: 18px;
}
.medtakeblock {
    width: calc(100% - 25px);
    height: 25px;
    position: relative;
    left: 25px;
    top: 6px;
}
.green {
    background-color: green;
}
.medname {
    display: inline-block;
    position: relative;
    font-size: 13px;
    margin-left: 23px;
    margin-top: 5px;
    font-weight: 100;
}
.medtakeblock div {
    width: 50px;
    height: 17px;
    border: 1px solid #ececec;
    border-radius: 10px;
    position: relative;
    left: calc(100% - 70px);
    margin-top: -18px;
    cursor: pointer;
}
.medtakeblock div p {
    position: relative;
    text-align: center;
    font-size: 12px;
    margin-top: 1px;
}
.blue {
    background-color: #35a1bb;
}
#timelinecontainer {
    position: fixed;
    width: 100%;
    height: 100%;
    bottom: 0px;
    display: inline-block;
    left: 0px;
    -webkit-overflow-scrolling: touch;
    overflow: scroll;
    z-index: 2;
}
#indent-line {
    width: 1px;
    height: 100%;
    position: fixed;
    background-color: #ececec;
    left: 25px;
    top: 0px;
    z-index: -1;
}
	</style>
	<script>
	function refreshtimeline() {
		$.ajax({
			method: 'GET',
			url: 'http://medicloud.io/timelineapi?auth=c67f85179fa1475ebd505cc3b88ecc98',
			success: function(data) {
				$('body').html(data);
			},
		});
	}

	$('.medtakeblock div').on('click', function() {
			str = $(this).find('.takeinfo').text();
			$.ajax({
				method: 'GET',
				url: 'http://medicloud.io/takemedicationapi?i='+str,
				success: function() {
					refreshtimeline();
				},
			});
		});
	</script>

	"
	render :html => final.html_safe
end

def takemedicationapi
	#"0,7"
	expectedparam = params[:i]
	daysag = expectedparam.split(",")[0].to_i
	medid = expectedparam.split(",")[1].to_i
	med = Medication.find(medid)
	if med.datapoints.include? ["#{Date.today + daysag.to_i}", "true"]
		med.datapoints.delete(["#{Date.today + daysag.to_i}", "true"])
		med.save!
		render :text => ""
	else
		med.datapoints.push ["#{Date.today + daysag.to_i}", "true"]
		med.save!
		render :text => ""
	end
end

def generatemeds
	userident = User.where(:auth_token => params[:auth]).pluck(:id).first()
	finalhtml = ""
	Medication.all.each do |medication|
		if decrypt(medication.userid) == userident
			finalhtml = finalhtml + "<div class = 'medicationbox mbox'>
				<span class = 'idtag' style = 'display: none;'>"+"#{medication.id}"+"</span>
        	    <p id = 'medtitlename'><span class = 'medactname'>#{decrypt(medication.name)}</span>, #{decrypt(medication.dose)}</p>
        	    <p id = 'medlasttaken'>Last Taken: YY:YYam</p>
        	    <img src = 'img/fwd_arrow.png' id = 'forwardmedarrow' style = 'margin-top: 18px;'>
        	</div>"
    	end
	end
	render :html => finalhtml.html_safe
end

def generatenotes
	userident = User.where(:auth_token => params[:auth]).pluck(:id).first()
	finalhtml = ""
	d = 0
	Note.all.each do |note|
		if decrypt(note.userid) == userident
			d += 1
			finalhtml = finalhtml + "<div class = 'medicationbox notebox'>
				<span class = 'noteidtag' style = 'display: none;'>"+"#{encrypt(note.id)}"+"</span>
				<p id = 'medtitlename'><span class = 'medactname'>#{decrypt(note.name)}</span></p>
				<p id = 'medlasttaken'>Created: #{note.created_at.to_time.strftime('%x')}</p>
				<p id = 'pillsreminderlabel'>#{decrypt(note.notecontent)[0...15]}...</p>
				<img src = 'img/fwd_arrow.png' id = 'forwardmedarrow'>
			</div>"
		end
	end
	(20 - (d * 0.66).ceil).times do
		finalhtml = finalhtml + "<div class = 'horizontalline'></div>"
	end
	render :html => finalhtml.html_safe
end


def createthedb
	if params[:term].length >= 3
    	arry = MedDb.search(params[:term])
 		meds = []
 		for g in arry
 			meds.append g.name
 		end
    	if meds.length > 2
    		meds.reject! {|x| x.length > 30}
    		sorted = meds.sort_by(&:length).first(5)
    		render :json => sorted
    	else
    		render :json => meds
    	end
	else
		render :json => []
	end
=begin
	string = "concert"
	letterscorrect = 0
	index = 0
	stop = false
	@dblength = [0, 24094]
	letters = []
	rendered = false
	i = 0
	while stop == false && i < 20
		i += 1
		middle = (@dblength[1] + @dblength[0]) / 2
		split = MedDb.find(middle).name.downcase
		if split.length > letterscorrect && string.length > letterscorrect
		if split[letterscorrect].ord > string[letterscorrect].ord && split[0, letterscorrect] == string[0, letterscorrect]
			@dblength = [@dblength[0], middle]
		elsif split[letterscorrect].ord < string[letterscorrect].ord && split[0, letterscorrect] == string[0, letterscorrect]
			@dblength = [middle, @dblength[1]]
		elsif split[letterscorrect].ord < string[letterscorrect].ord && split[letterscorrect - 1].ord < string[letterscorrect - 1].ord
			@dblength = [middle, @dblength[1]]
		elsif split[letterscorrect].ord < string[letterscorrect].ord && split[letterscorrect - 1].ord > string[letterscorrect - 1].ord
			@dblength = [@dblength[0], middle]
		elsif split[letterscorrect].ord > string[letterscorrect].ord && split[letterscorrect - 1].ord < string[letterscorrect - 1].ord
			@dblength = [middle, @dblength[1]]
		elsif split[letterscorrect].ord > string[letterscorrect].ord && split[letterscorrect - 1].ord > string[letterscorrect - 1].ord
			@dblength = [@dblength[0], middle]
		elsif split[letterscorrect].ord == string[letterscorrect].ord && split[0, letterscorrect] == string[0, letterscorrect]
			if letterscorrect < (string.length - 1)
				letterscorrect += 1
			else
				stop = true
			end
			letters.append split[letterscorrect - 1]
			if split[letterscorrect].ord > string[letterscorrect].ord
				@dblength = [@dblength[0], middle]
			elsif split[letterscorrect].ord < string[letterscorrect].ord
				@dblength = [middle, @dblength[1]]
			end
			if split == string
				stop = true
				render :text => "Medication found in #{i} moves."
				rendered = true
			else
				if (@dblength[1] - @dblength[0]) < 10
					for x in (@dblength[0] - 5 .. @dblength[1] + 5)
						if MedDb.find(x).name == string
							stop = true
							render :text => "Medication found in #{i} moves."
							rendered = true
						end
					end
				end
			end
		end
		end
	end
	if rendered == false && MedDb.where(:name => string).empty?
		render :text => "Medication not found."
	else
		if rendered == false
			render :text => "Medication found in failed moves. #{@dblength} #{letters} #{letterscorrect}"
		end
	end
=end
end

def createmedication
	@result = JSON.parse(open("http://rxnav.nlm.nih.gov/REST/rxcui.json?name=#{params[:medname].tr(' ', '_')}&allsrc=0&search=1").read)['idGroup']['rxnormId']
	userident = User.where(:auth_token => params[:auth]).pluck(:id).first()
	if @result
		mer = "am"
		if params[:taketime].to_s.split(':')[0].to_i >= 12
			mer = "pm"
		end
		if params[:toggle] == "on"
			@med = Medication.new(:userid => encrypt(userident), :name => encrypt(params[:medname]), :schedule => encrypt("#{params[:times]} times/#{params[:timeunit]}"), :dose => encrypt("#{params[:dosenum]}#{params[:doseun]}"), :notification_time => encrypt("#{params[:taketime].to_s.split(':')[0].to_i % 12} #{mer}"), :interaction_id => encrypt(@result.first))
		else
			@med = Medication.new(:userid => encrypt(userident), :name => encrypt(params[:medname]), :schedule => encrypt("0 times/day"), :dose => encrypt("#{params[:dosenum]}#{params[:doseun]}"), :interaction_id => encrypt(@result.first))
		end
		@med.save
	end
	render :text => "success"
end

def createnote
	userident = User.where(:auth_token => params[:auth]).pluck(:id).first()
	@note = Note.new(:userid => encrypt(userident), :name => encrypt(params[:notename]), :notecontent => encrypt(params[:notecontent]))
	@note.save
	render :text => "success"
end

def getnotei
	note = Note.find(decrypt(params[:d]))
	userident = User.where(:auth_token => params[:auth]).pluck(:id).first()
	if decrypt(note.userid) == userident
		render :text => decrypt(note.notecontent)
	else
		render :text => "invalid"
	end
end

def deletemedapi
	if params[:med].present?
		Medication.destroy(params[:med])
		render :text => ""
	end
end

def deletenoteapi
	if params[:note].present?
		Note.destroy(decrypt(params[:note]))
		render :text => ""
	end
end

def getnoteinfo
	@note = Note.find(params[:id])
	render :json => [@note.name, @note.notecontent]
end

def getmedinfoweb
	medications = []
		Medication.where(:id => decrypt(params[:ind])).each do |med|
			dun = decrypt(med.dose)
			["mg", "g", "ml", "L"].each do |rep| 
				dun.gsub!(rep, "")
			end
			dmes = decrypt(med.dose).gsub(dun, "")
			nottime = decrypt(med.notification_time).split(" ")
			dem = {:name => decrypt(med.name), :schedule => decrypt(med.schedule), :dose => decrypt(med.dose), :id => encrypt(med.id), :un => dmes, :mes => dun.to_i, :ttimes => decrypt(med.schedule).split(" ")[0], :trate => decrypt(med.schedule).split(" times/")[1].capitalize, :prectimenum => nottime[0], :prectimeun => nottime[1]}                      

			@medsforday = generate(decrypt(med.userid), 31)
			
			@takendays = {}
			qd = 0
			31.times do
				@takendays[qd] = []
				qd += 1
			end
			med.datapoints.each do |datapoint|
				daysago = (Date.today - datapoint[0].to_date).to_i
				if daysago < 31
					if datapoint[1] == "true"
						@takendays[daysago].push med.id
					end
				end
			end

			@adherencegraph = {}
			qb = 1
			31.times do
				@adherencegraph[qb] = 0.0
				qb += 1
			end

			@medsforday.each do |day, idarr|
				idarr.each do |id|
					if id == med.id
						@adherencegraph[day + 1] += 1
					end
				end
			end

			medspecifarry = {}
			qt = 1
			31.times do
				medspecifarry[qt] = 0
				qt += 1
			end
			@takendays.each do |day, idarr|
				idarr.each do |id|
					if id == med.id
						medspecifarry[day + 1] += 1
					end
				end
			end
			@adherencegraph.each do |day, count|
				if medspecifarry[day] != 0 && count != 0
					@adherencegraph[day] = medspecifarry[day].to_f / count * 100
				elsif medspecifarry[day] == 0 && count != 0
					@adherencegraph[day] = 0.0
				end
			end
			
			medications = [dem, @adherencegraph]
			
		end
	render :json => medications
end

def getnoteinfoweb
	notes = []
	Note.all.each do |note|
		if decrypt(note.userid) == viewuser.id
			note.name = decrypt(note.name)
			note.notecontent = decrypt(note.notecontent)
			notes.push note
		end
	end
	render :json => notes[decrypt(params[:ind]).to_i - 1]
end

def registerdevice
	@user = User.find(params[:id])
	if @user.deviceids.include? params[:devid]
		render :text => @user.deviceids
	else
		@user.deviceids.push params[:devid]
		@user.save!
		render :text => "sweet"
	end
end

def sendnotification
	@u = User.find(1).deviceids
	for e in @u
		APNS.send_notification(e, :alert => "You have 2 medications to take.", :message => "hello")
	end
	render :text => " "
end

def checkforinteractions

end

def remotesignin
    user = []
    uid = 0
  	User.all.each do |us|
      user.push us unless decrypt(us.fullname) != params[:username]
    end
  	user.each do |u|
  		if u.authenticate(params[:password])
  			uid = u
  		end
  	end
  	if uid != 0
  		render :json => uid
  	else
  		render :json => 2
  	end
end
	
def remoteregistration
end

#class end
end




























