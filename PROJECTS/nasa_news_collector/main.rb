require_relative "library/base_handler"
require "tqdm"

base_handler = Base_handler.new
base_handler.start_program
initialize_request = base_handler.http_request_nasa_server
unknown_types = initialize_request[0]
search_result = initialize_request[1]

size = search_result.size
sleep_value = delay_value(size, 0)

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

if unknown_types.size != 0
  base_handler.exception_logging(unknown_types)
end