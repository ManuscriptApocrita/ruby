require_relative "library/base_handler"
require "tqdm"

base_handler = Base_handler.new
base_handler.start_program
search_result = base_handler.http_request_nasa_server

size = search_result.size
if size > 1000
  sleep_value = 0.002
elsif size < 1000 && size > 500
  sleep_value = 0.02
elsif size < 500 && size > 200
  sleep_value = 0.05
elsif size < 200 && size > 100
  sleep_value = 0.1
elsif size < 100
  sleep_value = 0.15
end

search_result.with_progress(desc: "Reading JSON file").each_with_index do |release, index|
  base_handler.processing_press_release(release, index)
  sleep(sleep_value)
end

base_handler.accumulation_and_branching(search_result)
entries_size = base_handler.entries_size?

if entries_size > 0
  puts "#{entries_size} entries have been added!"
else
  puts "Your database is up to date! No changes were made..."
end