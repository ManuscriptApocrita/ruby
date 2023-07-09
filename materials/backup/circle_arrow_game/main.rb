require_relative "library/colorize"
require_relative "library/game"
require "time"
require "io/console"

system("cls") || system("clear")
puts "This program contains several games that contribute to the clear work of the brain." #Вводный инструктаж
puts
puts "Rules:"
puts "The user selects the arrow from left to right in order by the provided control keys"
puts "The game has several levels, the higher the level, the more the sequence of arrows and colors are\nadded to them to indicate them - press the first letter of the word of the met color on the keyboard"
puts
puts "    ↑"
puts "    W"
puts "← A S D →"
puts "    ↓"
puts
puts "R - " + "⚫".colorize(31) + " G - " + "⚫".colorize(32) + " Y - " + "⚫".colorize(33) + " B - " + "⚫".colorize(34)
puts
puts "Go to the game by clicking `Enter`"

until (user_input = gets.chomp).empty?
  user_input = gets.chomp
end

game_setting = Game.new

system("cls") || system("clear")
game_setting.circle_arrow_game #Запуск экземпляра класса игры, вход в игру