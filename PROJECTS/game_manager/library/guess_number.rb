def guess_number
	system("cls") || system("clear")

	random_number = rand(16)

	puts "Guessed a number from 0 to 15, guess, you have three attempts!"
	puts

	user_input = gets.chomp.to_i

	contruction(user_input, random_number)

	user_input = gets.chomp.to_i

	contruction(user_input, random_number)

	user_input = gets.chomp.to_i

	contruction(user_input, random_number)

	puts
	puts "Failed to win. Random number: " + random_number.to_s
end

def contruction(user_input, rndnum)
	if user_input == rndnum
		abort "You guessed the number!"
	else

		if (user_input - rndnum).abs > 2
			puts "Cold!"
		else
			puts "Warm!"
		end

		if user_input > rndnum
			puts "Need less..."
		else
			puts "Need more..."
		end
	end
end