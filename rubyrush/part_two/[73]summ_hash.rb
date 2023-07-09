#Написать программу, которая объединяет хэши в один и выводит его на экран.

magazine_one = {
  "apple" => 3,
  "lemon" => 2,
  "potato" => 4
}

magazine_two = {
  "soap" => 4,
  "towel" => 2,
  "shampoo" => 1
}

puts "Here full list to buy..."

magazine_one.merge!(magazine_two) #по итогу командой merge возвращается один хэш, полученный из двух

magazine_one.each do |key, value| #перебираю хэш и вывожу в надлежащем виде
  puts "#{key}: #{value}"
end