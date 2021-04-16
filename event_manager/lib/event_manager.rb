# Required Modules
require 'csv'
require 'date'
require 'erb'
require 'google/apis/civicinfo_v2'

# API Setup
civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

# File imports / template setup
template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

# Methods
def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phone_number(phone_number)
  phone_number.gsub!(/[^\d]/,'')
  if phone_number.length == 10
    phone_number
  elsif phone_number.length == 11 && phone_number[0] == "1"
    phone_number[1..10]
  else
    ""
  end
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir('output') unless Dir.exists?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def find_hour(reg_date)
  reg_hour = DateTime.strptime(reg_date, '%M/%d/%y %k:%M')
  reg_hour.strftime('%l %p')
end

def find_day(reg_date)
  reg_day = DateTime.strptime(reg_date, '%M/%d/%y %k:%M')
  reg_day.strftime('%A')
end

def average_day(array)
  day = array.max_by {|x| array.count(x)}
  puts "Average Day: #{day}"
end

def average_hour(array)
  hour = array.max_by {|x| array.count(x)}
  puts "Average Hour: #{hour}"
end

puts 'EventManager initialized.'

# Parse CSV file
contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

registration_days = []
registration_hours = []

contents.each do |row|
  # Rows
  id = row[0]
  reg_date = row[:regdate]
  first_name = row[:first_name].capitalize
  last_name = row[:last_name].capitalize
  zipcode = clean_zipcode(row[:zipcode])
  phone_number = clean_phone_number(row[:homephone])

  # Custom Variables
  hour = find_hour(reg_date)
  day = find_day(reg_date)
  legislators = legislators_by_zipcode(zipcode)
  form_letter = erb_template.result(binding)

  # Actions
  save_thank_you_letter(id,form_letter)
  registration_days.push(day)
  registration_hours.push(hour)
end

average_day(registration_days)
average_hour(registration_hours)
