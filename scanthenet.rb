require 'net/http'
require 'json'
require 'uri'

API_URL = "https://api.scanthe.net/"
MAX_ENTRIES_DEFAULT = 100

def print_logo
  puts "\n  _______                    _______ __           ____ __         __"
  puts " |     __|.----.---.-.----- |_     _|  |--.-----.|    |  |.-----.|  |_"
  puts " |__     ||  __|  _  |     |  |   | |     |  -__||       ||  -__||   _|"
  puts " |_______||____|___._|__|__|  |___| |__|__|_____||__|____||_____||____|\n\n"
end

def fetch_data
  uri = URI.parse(API_URL)
  response = Net::HTTP.get_response(uri)

  unless response.is_a?(Net::HTTPSuccess)
    puts "Error: HTTP request failed with status #{response.code}."
    exit 1
  end

  json_response = JSON.parse(response.body)

  unless json_response.key?('data') && json_response['data'].is_a?(Array)
    puts "Error: 'data' key not found or is not an array in JSON response."
    puts json_response
    exit 1
  end

  json_response['data']
end

def display_data(entries, max_entries)
  entries.first(max_entries).each do |entry|
    puts "ID: #{entry['id']}"
    puts "Timestamp: #{entry['timestamp']}"
    puts "Source IP: #{entry['source_ip']}"
    puts "Source Port: #{entry['source_port']}"
    puts "Destination Port: #{entry['dest_port']}"
    puts "Data: #{entry['data']}"
    puts "----------"
  end
end

def main
  print_logo

  max_entries = ARGV[0] ? ARGV[0].to_i : MAX_ENTRIES_DEFAULT

  if max_entries < 1 || max_entries > 100
    puts "Please enter a number between 1 and 100."
    exit 1
  end

  data = fetch_data
  display_data(data, max_entries)
end

main
