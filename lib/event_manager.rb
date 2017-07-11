#PROJECT FROM
#http://tutorials.jumpstartlab.com/projects/eventmanager.html

require "csv"
require "erb"
require "sunlight/congress"

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

#zipcode.length = 5 checker/ensurer
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4] #fk me this is good
end

def legs_by_zip(zipcode)
 Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id, form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts "Event Manager Initialized!"

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

contents.each do |row|
  id = row[0]
  name = row[:first_name] #nice trick yo, use this later

  zipcode = clean_zipcode(row[:zipcode]) #jumps zipcode = row[:zipcode]

  legislators = legs_by_zip(zipcode)

  form_letter = erb_template.result(binding)

  save_thank_you_letters(id, form_letter)
end

#finish the extra tasks later

#PROJECT FROM
#http://tutorials.jumpstartlab.com/projects/eventmanager.html
