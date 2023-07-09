require 'selenium-webdriver'

array = ["chrome", "firefox", "edge", "safari"]

puts "Данная программа может инициировать запуск браузера и поиск в Wikipedia!"
puts "Выберите браузер, который есть в наличии:"

array.each_with_index do |item,index|
  puts "#{index + 1}. #{item}"
end

user_input = gets.to_i

until (1..4).include?(user_input)
  user_input = gets.to_i
end

puts "Введите запрос для поиска:"

search_query = gets.chomp

begin
driver = Selenium::WebDriver.for(:"#{array[user_input - 1]}")
rescue
  abort "Инициализация браузера прошла с ошибкой!"
end

driver.navigate.to("https://ru.wikipedia.org") #переход на сайт сразу при открытии браузера

search_field = driver.find_element(id: "searchInput") #запомнить поле поиска
search_field.send_keys(search_query) #отдать в поле информацию, введенную ранее

search_button = driver.find_element(id: "searchButton")
search_button.click #запомнить кнопку и вызвать у неё функцию клик, чтобы перейти к результатам