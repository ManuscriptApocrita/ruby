require_relative 'library/functions'
require 'mechanize'

agent = Mechanize.new
begin
  html = agent.get("https://segodnya.tv/") #если на этом этапе ошибка - подключени к интернету отсутствует
rescue
  abort "У вас нет подключения к интернету."
end

days_links = processing_all_days(html)

puts "В работе используется информация с сайта: `segodnya.tv`"
puts "Данное приложение позволяет посмотреть расписание по разным телеканалам, выберите день: \n\n"

puts "0. Сегодняшний день"
days_links.each do |key, value|
  puts "#{key + 1}. #{Date.parse(value[0]).strftime("%d %B")}"
end

user_input = gets.to_i
until (0..(days_links.size + 1)).include?(user_input)
  puts "Введите доступное значение!"
  user_input = gets.to_i
end

if user_input != 0
  day = days_links[user_input - 1][0].split(" ").shift
end

system("cls") || system("clear")

if user_input == 0 #если выбран сегодняшний день
  result_hash = processing_day(html)
else
  new_html = agent.get("https://segodnya.tv#{days_links[user_input - 1][1]}") #формирую ссылку с основным каркасом и добавочным элементом для перехода к конкретному месту, выбранному выше
  result_hash = processing_day(new_html)
end

result_hash.each_with_index do |(key, value),index|
  puts "#{index + 1}. #{key}"
end

user_input = gets.to_i
until (1..28).include?(user_input)
  puts "Введите доступное значение!"
  user_input = gets.to_i
end

system("cls") || system("clear")

channel = result_hash.keys[user_input - 1]
if not day.nil?
  puts "Канал: `#{channel}` на #{day} число\n\n"
else
  puts "Канал: `#{channel}` на сегодня\n\n"
end

counter = 0
(result_hash[channel][0]).size.times do
  puts "#{result_hash[channel][1][counter]} - #{result_hash[channel][0][counter]} \n\n"
  counter += 1
end