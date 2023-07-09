#Дан JSON-файл, где для каждого языка программирования указано количество вакансий.
# Необходимо отсортировать этот список по убыванию популярности языка и вывести
# победителя отдельной строкой.

require "json"

file = File.read(File.dirname(__FILE__) + "/[88]most_popular_languages.json")
data = JSON.parse(file)

counter = 1 #счетчик для итераций вывода информации

puts "Most popular language of programming: PHP (#{data["PHP"]})" #отдельно вывожу самый популярный язык :D (пользуюсь базой с примера, сейчас все может быть и не так)

data.sort_by {|key, value| -value}.to_h.each do |key, hash| #сортирую по значению, потом обратно делаю хэш и вывожу по нему данные в правильном виде
  puts "#{counter}: " + key + " (#{hash})"
  counter += 1
end
