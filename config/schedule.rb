# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#

every 1.day, :at => '4:25 pm' do
  runner "User.medifications"
end

every 1.day, :at => '12:00 pm' do
  runner "User.medifications"
end
every 1.day, :at => '1:00 pm' do
  runner "User.medifications"
end
every 1.day, :at => '2:00 pm' do
  runner "User.medifications"
end
every 1.day, :at => '3:00 pm' do
  runner "User.medifications"
end
every 1.day, :at => '4:00 pm' do
  runner "User.medifications"
end
every 1.day, :at => '5:00 pm' do
  runner "User.medifications"
end
every 1.day, :at => '6:00 pm' do
  runner "User.medifications"
end
every 1.day, :at => '7:00 pm' do
  runner "User.medifications"
end
every 1.day, :at => '8:00 pm' do
  runner "User.medifications"
end
every 1.day, :at => '9:00 pm' do
  runner "User.medifications"
end
every 1.day, :at => '10:00 pm' do
  runner "User.medifications"
end
every 1.day, :at => '11:00 pm' do
  runner "User.medifications"
end
every 1.day, :at => '12:00 am' do
  runner "User.medifications"
end
every 1.day, :at => '1:00 am' do
  runner "User.medifications"
end
every 1.day, :at => '2:00 am' do
  runner "User.medifications"
end
every 1.day, :at => '3:00 am' do
  runner "User.medifications"
end
every 1.day, :at => '4:00 am' do
  runner "User.medifications"
end
every 1.day, :at => '5:00 am' do
  runner "User.medifications"
end
every 1.day, :at => '6:00 am' do
  runner "User.medifications"
end
every 1.day, :at => '7:00 am' do
  runner "User.medifications"
end
every 1.day, :at => '8:00 am' do
  runner "User.medifications"
end
every 1.day, :at => '9:00 am' do
  runner "User.medifications"
end
every 1.day, :at => '10:00 am' do
  runner "User.medifications"
end
every 1.day, :at => '11:00 am' do
  runner "User.medifications"
end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
