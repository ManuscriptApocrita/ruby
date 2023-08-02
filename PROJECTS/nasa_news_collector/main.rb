require_relative "library/base_handler"
require "tqdm"

base_handler = Base_handler.new

search_result = base_handler.http_request_nasa_server
search_result.with_progress(desc: "Reading JSON file...").each_with_index do |release, index|
  base_handler.processing_press_release(release, index)
  sleep(0.005)
end

base_handler.accumulation_and_branching(search_result)
entries_size = base_handler.entries_size?

if entries_size > 0
  puts "#{entries_size} entries have been added!"
else
  puts "Your database is up to date! No changes were made..."
end