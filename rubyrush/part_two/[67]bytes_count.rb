#Написать программу, которая показывает, сколько байт занимает в памяти компьютера целое число
#42 и строка "Вася".

string = "Vasya"
number = 42

puts "In string #{string} - #{string.bytesize} bites"
puts "In number #{number} - #{number.size} bites"