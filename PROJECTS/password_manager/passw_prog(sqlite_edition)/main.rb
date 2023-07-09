$:.unshift File.dirname($0)
require_relative "password_generator"
require_relative "password_examination" #метод проверки пароля на устойчивость к взлому
require_relative "security_manager"
require_relative "colorize" #библиотека колоризации текста

system("clear") || system("cls")

puts "Write a master key to access the program..."

user_input = gets.chomp

if user_input != "eas33"
  puts "You input wrong master key!"
  sleep(1)
  exit
end

security_manager = Security_manager.new
security_manager.encryption_tool_update

password_generator = Password_generator.new
password_generator.files_initialize

loop do
  system("clear") || system("cls")

  puts "[Password manager APP] version 2".green + " <sqlite edition>".pink
  puts
  puts "This application has a flexible setting for password generation and further storage in a secure database."
  puts
  puts " 1. MNEMONIC gen. (words are used, their number is specified by the user)"
  puts " 2. RANDOMLY gen. (consists of random characters, letters and numbers. Length specified by the user)"
  puts " 3. MANUALLY input (password and login to the database)"
  puts
  puts " 4. View saved password database"
  puts " 5. Examination of input password (degree of security)"
  puts
  puts "Write \"exit\" to exit the program"
  print ">"

  user_input = gets.chomp

  until user_input == "exit" || user_input == "update" || user_input.to_i == 1 || user_input.to_i == 2 || user_input.to_i == 3 || user_input.to_i == 4 || user_input.to_i == 5
    puts "Input correct answer..."
    user_input = gets.chomp
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
    security_manager.print_sqlite_base #посмотреть базу паролей
  elsif user_input.to_i == 5
    security_password_check
  end
end