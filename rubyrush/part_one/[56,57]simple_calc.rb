#1. Написать простенький калькулятор, который умееет делать операции с двумя целыми (и только
#целыми) числами: сложение, вычитание, умножение, деление. Числа и операцию он по очереди
#спрашивает у пользователя. Добавить в этот калькулятор обработку ошибок при попытке деления на ноль
#2. Написать калькулятор, который работает с числами с плавающей точкой.

# puts "Input first number:"
# number_one = gets.to_i
#
# puts "Input second number:"
# number_two = gets.to_i
#
# puts "Select math operation - (+ - * /):"
# math_operation = gets.chomp.to_s
#
# if math_operation == "+"
# 	puts number_one + number_two
# elsif math_operation == "-"
# 	puts number_one - number_two
# elsif math_operation == "*"
# 	puts number_one * number_two
# elsif math_operation == "/"
# 	begin
# 	puts number_one / number_two
# 	rescue ZeroDivisionError
# 		puts "Division by zero is not possible!"
# 	end
# else
# 	puts "This operation not provided in this programm..."
# end

puts "Input first number:"
number_one = gets.to_f
puts "Input second number:"
number_two = gets.to_f
puts "Select math operation - (+ - * /):"
math_operation = gets.chomp.to_s
puts "Result:"

case math_operation
when "+"
	puts number_one + number_two
when "-"
	puts number_one - number_two
when "*"
	puts number_one * number_two
when "/"
	puts number_one / number_two
else
	puts "This operation not provided in this programm..."
end