#1. Напишу свой мод программы diary, сделанной ранее, используя sqlite и опираясь на показанные примеры.
#2. Внедрить обработчик ошибок

require_relative "library/write_read" #сначала нужен основной класс
require_relative "library/note"
require_relative "library/task"

puts "This program is designed to accumulate textual information." #показываю возможности
puts "It is sorted by date and number of entered information."
puts "\nWhat`s you need to input in note?"

array = [Note, Task]

array.each_with_index do |type, index| #Показываю возможные выборы записей в записную книжку (нумерация элементов с единицы :--)
  puts "#{index + 1}. " + "#{type} "
end

puts "\n3. If you want read base and make changes"

user_input = ""

until user_input == 1 || user_input == 2 || user_input == 3 #проверка на ввод
  user_input = gets.to_i
end

if user_input == 3
  WriteRead.read_base
end

type_class = array[user_input - 1].new #обращаюсь к элементу массива опираясь на ввёденный индекс элемента пользователем

type_class.read_from_console

type_class.save

puts "Your post save!"