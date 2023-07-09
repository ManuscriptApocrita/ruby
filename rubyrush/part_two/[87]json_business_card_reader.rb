#Сделать визитку из предыдущих заданий еще и в формате JSON и написать программу, которая
# читает визитку в формате JSON и выводит её на экран

require "json" #запрашиваю нужную библиотеку!

file = File.read(File.dirname(__FILE__) + "/[87]json_business_card.json") #прокладываю путь

data = JSON.parse(file) #парсинг данных, вовзращается ассоциативный массив!

puts data["name"] #вывожу значения по ключу
puts "#{data["number"]}, #{data["email"]}"
puts data["information"]
