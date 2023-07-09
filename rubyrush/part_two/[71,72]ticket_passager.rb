#1. Написать программу, которая выводит билет пассажира поезда. Использовать своё воображение и ассоциативные массивы.
#2. Составить массив хэшей с несколькими пассажирами в вагоне, индекс хэша в массиве - место пассажира в вагоне. Затем вывести все билеты на экран

# passenger = {
#   "name" => "Okko Zeland",
#   "ticket" => "RS20",
#   "route" => "Ohio - New Zeland",
#   "passenger" => "Acco Rodero",
#   "passport" => "0101 204443"
# }

# puts "Name: #{passenger["name"]}" #Вывожу построчно значения ключей, прежде описывая их
# puts "Ticket number: #{passenger["ticket"]}"
# puts "Route: #{passenger["route"]}"
# puts "Passenger: #{passenger["passenger"]}"

passengers = [
  {"name" => "Okko Zeland",
  "ticket" => "RS20",
  "route" => "Ohio - New Zeland",
  "passenger" => "Acco Rodero"},
  {"name" => "Longli Sebas",
  "ticket" => "RA30",
  "route" => "USA - Topaz",
   "passenger" => "Longli Sebas"}]

puts "Passengers on a train from Example to New Zealand"

passengers.each_with_index do |passenger, number|
  puts "<< site № #{number + 1} >>"
  puts "Ticket № #{passenger["ticket"]}"
  puts "Route: #{passenger["route"]}"
  puts "Passenger: #{passenger["name"]}"
end
