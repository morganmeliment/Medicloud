class DashboardController < ApplicationController

  def index
  	# Set @daystoconsider to the amount of days you want to include
  	@daystoconsider = 31

  	# @medsfordays will be the days that the medication is supposed to be taken, 100% adherence
	@medsfordays = {}

	b = 0
	@daystoconsider.times do
		@medsfordays[b] = []
		b += 1
	end

	# This calculates @medsfordays
	Medication.where(:userid => viewuser.id).each do |medication|
		frequency = medication.schedule
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

	# Calculate days where the medication was actually taken
	@takendays = {}
	qd = 0
	@daystoconsider.times do
		@takendays[qd] = []
		qd += 1
	end
	medications = Medication.where(:userid => viewuser.id)
	medications.each do |medication|
		medication.datapoints.each do |datapoint|
			daysago = (Date.today - datapoint[0].to_date).to_i
			if daysago < @daystoconsider
				if datapoint[1] == "true"
					@takendays[daysago].push medication.id
				end
			end
		end
	end

	# Calculate adherence percent
	@adherencebyday = []
	@medsfordays.each do |daysago, medicationstotake|
		if @takendays[daysago].count != 0 && medicationstotake.count != 0
			@takendays[daysago].count.times do
				@adherencebyday.push 1.0
			end
			(medicationstotake.count - @takendays[daysago].count).times do
				@adherencebyday.push 0.0
			end
		elsif @takendays[daysago].count == 0 && medicationstotake.count != 0
			@adherencebyday.push 0.0
		end
	end
	totalad = 0
	@adherencebyday.each do |adhnum|
		totalad += adhnum
	end

	# Create data for final overall adherence graph [[date_index, percent_taken]]
	@adherencearray = []
	@medsfordays.each do |daysagoone, medicationstotakeone|
		if @takendays[daysagoone].count != 0 && medicationstotakeone.count != 0
				@adherencearray.push [daysagoone, @takendays[daysagoone].count.to_f / medicationstotakeone.count]
		else
			@adherencearray.push [daysagoone, 0.0]
		end
	end

	# Create data for each individual adherence graph
	@adherencegraphs = []
	Medication.where(:userid => viewuser.id).each do |med|
		@adherencegraph = {}
		qb = 0
		@daystoconsider.times do
			@adherencegraph[qb] = 0.0
			qb += 1
		end
		@medsfordays.each do |day, idarr|
			idarr.each do |id|
				if id == med.id
					@adherencegraph[day] += 1
				end
			end
		end
		medspecifarry = {}
		qt = 0
		@daystoconsider.times do
			medspecifarry[qt] = 0
			qt += 1
		end
		@takendays.each do |day, idarr|
			idarr.each do |id|
				if id == med.id
					medspecifarry[day] += 1
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
		@adherencegraphs.push @adherencegraph.to_a
	end

	# Final calculated adherence in @adherence
	if @adherencebyday.count != 0
		@adherence = (totalad.to_f / @adherencebyday.count.to_f * 100.0).round(1)
	else
		@adherence = 0
	end

  end

end
