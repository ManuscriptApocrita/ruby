require_relative "library/rock_scissor_paper"
require_relative "library/guess_the_word"
require_relative "library/arrow_circle_direction"
require_relative "library/guess_number"

puts "Hello! It`s a small game manager"
puts "available: \n 1. Rock Scissor Paper (mod) \n 2. Guess the word \n 3. Guess the number \n 4. Arrow & circle direction (brain train)"

user_input = gets.to_i

unless user_input == 1 || user_input == 2 || user_input == 3 || user_input == 4
  puts "Write correct answer..."
  user_input = gets.to_i
end

if user_input == 1
  game = RSP.new
  game.begin_rsp
elsif user_input == 2
  game = GTW.new
  game.begin_gtw
elsif user_input == 3
  guess_number
elsif user_input == 4
  game = ACD.new
  game.begin_acd
end