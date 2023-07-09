#Написать программу, которая шифрует введённое пользователем слово одним
#из механизмов MD5 или SHA1

require "digest" #Шикарная библиотека, сила в простоте. :D

puts "Input information for encoding..."

information_variable = gets.chomp #Беру информацию для шифровки

puts "Encryption method: " #даю выбор пользователю на тип шифровки
puts "1. MD5"
puts "2. SHA1"

user_choise = gets.to_i

if user_choise == 1 #шифрую в зависимости от выбора пользователя
  result = Digest::MD5.hexdigest(information_variable)
elsif user_choise == 2
  result = Digest::SHA1.hexdigest(information_variable)
else
  abort "Input correct answer..."
end

puts "Encode information: #{result}"