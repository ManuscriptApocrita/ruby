require 'nokogiri'
require 'open-uri'

begin
  html = URI.open("https://segodnya.tv/") #если на этом этапе ошибка - подключени к интернету отсутствует
rescue
  abort "У вас нет подключения к интернету."
end

document = Nokogiri::HTML(html) #тут происходит обработка гемом nokigiri, и предоставление его возможностей разработчику

schedule_units = document.css(".schedule-unit") #тут я помещаю в переменную все контейнеры класса `schedule-unit` (в этом классе находятся блоками данным о канале и что на нем идет в ближайшее время)

index = 0 #нужно для цикла

hash_tv = Hash.new

while index < schedule_units.size #условие: пока индекс меньше, чем количество блоков с информацией о каналах - нужна их обработка (логично, ведь я хочу все доступные блоки записать)

  schedule_unit = schedule_units[index] #тут происходит конкретизация, из всех доступных блоков я выбираю конкретный (по счету равный index)

  hash_tv[schedule_unit.at_css("a").text] #здесь создание ключа хэша с названием канала по порядку

  titles = schedule_unit.css("a").to_a.flatten.map { |element| element.text } #загружаются массивом в переменную названия телепередач, у них тег типа ссылка в html документе, flatten же нужен для создания обычного массива, до этого он модифицирован nokogiri и необычен =-)

  titles.shift #мусорные элементы, а именно первый (shift) и последний (pop) удаляются
  titles.pop

  times = schedule_unit.css(".b-time").map { |element| element.text } #информация о времени начала телепередач, она находится в классе b-time

  (titles.size).times do #связываю с правильной принадлежностью к каналу массивы телепередач и времени их начала
    hash_tv[schedule_unit.at_css("a").text] = [titles[1..7], times[1..7]]
  end

  index += 1
end

puts "В работе используется информация с сайта: `segodnya.tv`"
puts "Данное приложение позволяет посмотреть программу на день по разным телеканалам, выберите нужный: \n\n"

hash_tv.each_with_index do |(key, value),index|
  puts "#{index + 1}. #{key}"
end

user_input = gets.to_i

until (1..28).include?(user_input)
  puts "Введите доступное значение!"
  user_input = gets.to_i
end

system("cls") || system("clear")

channel = hash_tv.keys[user_input - 1]

puts "Канал: `#{channel}`"
puts

counter = 0

(hash_tv[channel][0]).size.times do
  puts "#{hash_tv[channel][1][counter]} - #{hash_tv[channel][0][counter]} \n\n"
  counter += 1
end

