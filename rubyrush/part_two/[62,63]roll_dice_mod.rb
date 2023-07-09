#1. Улучшить программу: пусть кубик «вращается» во время броска: сделать так, чтобы перед тем,
#как вывести произвольное число от 1 до 6, программа бы быстро отображала несколько сменяющих
#друг друга произвольных чисел — «граней кубика».
#2. Добавить ещё одно улучшение к программе: подсчёт суммы выпавших на кубиках чисел.

# def rolling_die #Метод вращения кубика!
# 	puts "The cube is spinning :D"
# 	10.times do
# 	print "#{rand(1..6)}\n"
# 	sleep 0.1
# 	end
# end

# puts "how many dice to throw?"

# user_input = gets.to_i

# rolling_die

# system ("clear")
# puts "Numbers dropped:"
# user_input.times do
# 	puts rand(1..6)
# end

def rolling_die
	puts "The cube is spinning :D"
	10.times do
	sleep 0.1
	print "#{rand(1..6)}\r"
	end
end

puts "how many dice to throw?"

user_input = gets.to_i

rolling_die

array = []
counter = 0

system ("clear")
puts "Numbers dropped:"
user_input.times do
	array << rand(1..6)
	puts array[counter]
	counter += 1
end

puts "Sum: " + array.sum.to_s