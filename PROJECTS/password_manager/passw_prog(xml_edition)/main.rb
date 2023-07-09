$:.unshift File.dirname($0)

require_relative "password_generator"
require_relative "security_manager"
require_relative "colorize" #библиотека колоризации текста
require "rexml/document" #работа с xml документом
require "date" #проверки на актуальность пароля
require "securerandom" #библиотека безопасного рандома :D ранее использовал обычный, но пусть будет этот, звучит надежнее

system("clear") || system("cls")

puts "Write a master key to access the program..."

user_input = gets.chomp

if user_input != "eas11"
  exit
end

security_manager = Security_manager.new
security_manager.encryption_tool_update

password_generator = Password_generator.new
password_generator.files_initialize

loop do
  system("clear") || system("cls")

  puts "[Password manager APP] version 1.2"
  puts
  puts "This application has a flexible setting for password generation and further storage in a secure database."
  puts "Select the desired item:"
  puts
  puts " 1. MNEMONIC gen. (words are used, their number is specified by the user)"
  puts " 2. RANDOMLY gen. (consists of random characters, letters and numbers. Length specified by the user)"
  puts " 3. MANUALLY input (password and login to the database)"
  puts
  puts " 4. View password database"
  puts
  puts "Write `exit` to exit the program"

  user_input = gets.chomp.to_s

  until user_input.to_i == 1 || user_input.to_i == 2 || user_input.to_i == 3 || user_input.to_i == 4 || user_input == "exit" || user_input == "update"
    puts "Input correct answer..."
    user_input = gets.to_s
  end

  if user_input == "exit"
    exit
  elsif user_input == "update"
    security_manager.counter_reset #сброс тумблеров
  elsif user_input.to_i == 1
    password_generator.word_password #мнемонический пароль
  elsif user_input.to_i == 2
    password_generator.randomize_password #случайная генерация
  elsif user_input.to_i == 3
    password_generator.add_manually #добавить вручную
  elsif user_input.to_i == 4
    security_manager.print_xml_base #посмотреть базу паролей
  end
end

