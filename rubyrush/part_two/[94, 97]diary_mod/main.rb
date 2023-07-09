# 1. Подготовка к написанию программы, сделать заготовки разных частей программы
# 2. Создать программу-блокнот, используя наследование классов

require_relative "library/write" #сначала нужен основной класс
require_relative "library/link"
require_relative "library/note"
require_relative "library/task"

puts "This program is designed to accumulate textual information." #показываю возможности
puts "It is sorted by date and number of entered information."
puts

puts "What`s you need to input in note?"

array = [Note, Task, Link]

array.each_with_index do |type, index|
  puts "#{index + 1}. " + "#{type} "
end

user_input = ""

until user_input == 1 || user_input == 2 || user_input == 3 #проверка на ввод
  user_input = gets.to_i
end

type_class = array[user_input - 1].new #обращаюсь к элементу массива опираясь на ввёденный индекс элемента пользователем

type_class.read_from_console

type_class.save

puts "Your post save!"