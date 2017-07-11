#PROJECT FROM
#http://tutorials.jumpstartlab.com/projects/eventmanager.html
#contents code is identical wiht event_manager.rb one, except bad_number check
#also, the code doesn't run in atom but runs in irb
#YO, THIS ^^^^ is important..tnx <3


require "csv"

def bad_number(number)
  number = number.gsub(/[^\d]+/, '') #transforms number to just digits
  if number.length == 10
    number
  elsif number.length == 11
    number[0] == "1" ? number[1..11] : "N/A"
  elsif number.length < 10 || number.length > 11
    "N/A"
  end
end

def best_time(date_time, regtime_hash) #finds most frequent hours of registration
  time = date_time.strftime("%k")#hour in 0..23 without padding (ex. no 04 but 4)

  regtime_hash[time] ||= 0
  regtime_hash[time] += 1
end

def print_best_time(regtime_hash) #use to print the most frequent times of registration by hour
  time_freq_ary = regtime_hash.sort_by {|k,v| v}.reverse

  puts
  puts "--Most frequent registrations by hour--"
  time_freq_ary.each do |elem|
    puts "#{elem[1]} registrations at #{elem[0]}h"
  end
end

def best_day(date_time, regdate_hash)
  weekday = date_time.wday

  regdate_hash[weekday] ||= 0
  regdate_hash[weekday] += 1
end

def print_best_day(regdate_hash)
  date_freq_ary = regdate_hash.sort_by {|k,v| v}.reverse

  puts
  puts "--Most frequent registrations by day--"
  puts "NOTE--sunday is day 0 and I am really bored to make a translator...."
  date_freq_ary.each do |elem|
    puts "#{elem[1]} registrations on day #{elem[0]}"
  end
end


contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol
regtime_hash = {}
regdate_hash = {}
time_format = "%m/%d/%y %H:%M" #change this if time format changes

contents.each do |row|
  name = row[:first_name]
  number = row[:homephone]
  regdate = row[:regdate]

  date_time =  DateTime.strptime(regdate, time_format)

  number = bad_number(number)
  best_time(date_time, regtime_hash)
  best_day(date_time, regdate_hash)

  puts "#{name} #{number}"
end

print_best_time(regtime_hash)
print_best_day(regdate_hash)
