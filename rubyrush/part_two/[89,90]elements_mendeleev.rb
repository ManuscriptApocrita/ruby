#1. Модернизировать программу про "Таблицу Менделеева", вынести элементы в отдельный файл Json и сделать вывод
#2. Усложнить программу, для каждого элемента в JSON файле нужно указать не только первооткрывателя, но и
# название, плотность, год открытия, а также порядковый номер. Переписать программу, чтобы она выводила более
# подробную информацию о выбранном элементе

require 'json'

file = File.read(File.dirname(__FILE__) + "/[114,115]elements_mendeleev_base.json")

data = JSON.parse(file)

puts "A program with which you can find out the discoverer of a chemical element." #Знакомлю пользователя с возможностями программы!
puts "#{data.keys.length} available elements of table Mendeleev: "

counter = 0
data.keys.size.times do #вывожу в одной строке все доступные
  print "#{data.keys[counter]} "
  counter += 1
end

puts "\n\nWhat element need information about?"

element = gets.chomp

if data.has_key?(element) #если то что ввёл пользователь есть в ключах хэша - информация выводится
  puts "Here information"
  data[element].each do |key, value|
    puts "#{key}: " + "#{value}"
  end
else
  puts "Element not found..."
end