#1. Написать программу "Сундук желаний". Программа спрашивает у пользователя в консоли, чего он хочет
# и до какой даты он хочет, чтобы его желание исполнилось, а потом записывает это всё в XML-файл
#2. Модифицировать программу, добавить скрипт, который выводит желания, которые уже должны были
# сбыться на текущий день и желания, которым еще предстоит сбыться

require "rexml/document"
require "date"
require_relative "library/list_wishes"
require_relative "library/wish"

file_path = File.dirname(__FILE__) + "/data/chest.xml"

unless File.exist?(file_path) #в случае если файла нету - создаю его с шапкой xml документа
  File.open(file_path) do |file|
    file.puts "<?xml version='1.0' encoding='UTF-8'?>"
    file.puts "<wishes></wishes>"
  end
end

file = File.read(file_path)
xml_document = REXML::Document.new(file)

puts "This chest provides accumulate your wishes!"
puts "1. WriteRead new wish"
puts "2. Read wishes"

user_input = gets.to_i

if user_input == 2
  read_wishes
  sleep(10)
  exit
end

puts "\nWhat`s you want write?"

user_input = gets.chomp

puts "Specify the time frame in the format: 01.01.2001"

while #пока не будет выполнена проверка регулярным выражением успешно - не пропускаю
  wish_date = gets.chomp

  if wish_date.match?(/^[0-9]{2}\.[0-9]{2}\.[0-9]{4}/)
    break
  else
    puts "Input correct data!"
  end
end

wish_date = Date.parse(wish_date) #превращаю в real дату

wish = xml_document.root.add_element("wish", {"date" => wish_date.strftime("%d.%m.%Y")}) #добавляю элемент в корневой раздел xml документа

wish.add_text(user_input) #текстом элемента будет желание

File.open(file_path, "w:UTF-8") do |file| #сохранение в utf-8!!!
  xml_document.write(file, 2)
end

puts "Enjoy!"