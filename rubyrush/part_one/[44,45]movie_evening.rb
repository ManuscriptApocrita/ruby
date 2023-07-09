#1. Написать программу, которая рекомендует фильм к просмотру, доставая его произвольно из файла
#со списком фильмов. Создать файл, со списком фильмов (одна строка - одно название). И написать
#программу, которая берёт произвольную строку и выводит название фильма на экран.
# 2. Дополнить предыдущую программу описанием к фильму. В файле со списком фильмов следующей строкой
# после название идет краткое описание. То есть каждая вторая строка файла содержит описание к
# фильму на предыдущей строке. А при вызове программы, выводить произвольный фильм с описанием.

# current_path = File.dirname(__FILE__)
# file_path = current_path + "/data/movies.txt"
#
# if File.exist?(file_path)
#   file = File.new(file_path, "r:UTF-8")
#   movies = file.readlines
#   file.close
# else
#   puts "File not found"
# end
# system("cls") || system("clear")
# number = rand(movies.size)
# puts "Today I advise you to watch:"
# puts movies[number]

current_path = File.dirname(__FILE__)

file_path = current_path + "/data/movies.txt"

if File.exist?(file_path)

  file = File.new(file_path, "r:UTF-8")

  movies = file.readlines

  file.close

else
  puts "File not found"
end

system("cls") || system("clear")

number = rand(movies.size)

if number % 2 == 1
  number -= 1
end

puts "Today I advise you to watch:"
puts movies[number]
puts movies[number + 1]