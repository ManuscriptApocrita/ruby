#1. усовершенствовать программу "Погода", добавив подробный прогноз на завтра
#2. ввести варианты ответа пользователю (другие города для показа погоды)

require "uri" #нужно для работы с URL
require "net/http" #нужно для загрузки данных по http протоколу
require "rexml/document" #работа с xml!
require_relative "library/data_processing" #метод обработки данных атрибутов элементов xml документов

cities = {"Екатеринбург" => 122, "Ростов-на-Дону" => 135, "Кисловодск" => 180, "Москва" => 32277, "Пятигорск" => 171}

loop do
  system("cls") || system("clear")

  puts "Программа показывает прогноз погоды на два дня, используя данные Meteoservice.ru"
  puts "\nВыберите интересующий город:"

  cities.keys.each_with_index do |item, index|
    puts "#{index + 1}. #{item}"
  end
  puts "\n6. Выход"

  user_input = gets.to_i

  while
    if user_input > 6 || user_input < 1
      puts "Введите корректный ответ!"
      user_input = gets.to_i
    elsif user_input == 6
      exit
    else
      break
    end
  end

  url = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{cities.values[user_input - 1]}.xml") #в зависимости от ответа пользователя выбирается индекс города

  begin
  request = Net::HTTP.get_response(url) #этим запросом можно взять сам сайт, который находится в body
  rescue
    puts "Ошибка! Сервер недоступен..." #в случае неполадок с сайтом или интернетом
    exit
  end

  xml_document = REXML::Document.new(request.body)

  city_name = URI.decode_uri_component(xml_document.root.elements["REPORT/TOWN"].attributes["sname"]) #по данному пути находится зашифрованное название города в формате URL-кодирования, декодирую, используя URI

  days = {1 => "Воскресенье", #для расшифровки данных в xml и приведения в желаемый вид
          2 => "Понедельник",
          3 => "Вторник",
          4 => "Среда",
          5 => "Четверг",
          6 => "Пятница",
          7 => "Суббота"}

  puts "\n#{city_name.upcase}"
  puts

  day = ""

  xml_document.root.elements.each("REPORT/TOWN/FORECAST") do |item| #перебор всех элементов по заданному пути
    if day != "#{days[item.attributes["weekday"].to_i]} (#{item.attributes["day"]} число)" #если день недели уже был выведен - нет нужды его снова показывать
      puts "#{days[item.attributes["weekday"].to_i]} (#{item.attributes["day"]} число)"
    end

    phenomena = item.elements["PHENOMENA"] #для простоты обращения к элементам
    temperature = item.elements["TEMPERATURE"]
    wind = item.elements["WIND"]
    relwet = item.elements["RELWET"]

    times_day(item.attributes["tod"]) #обращаюсь к методу, в зависимости от цифры в этом аттрибуте выводится соответствующая строка

    if temperature.attributes["min"] == temperature.attributes["max"] #если диапазона нету - показывать его не нужно
      print "температура #{temperature.attributes["max"]} градусов, "
    else
      print "температура от #{temperature.attributes["min"]} до #{temperature.attributes["max"]} градусов, "
    end

    phenomena(phenomena.attributes["cloudiness"], phenomena.attributes["precipitation"])

    if wind.attributes["min"] == wind.attributes["min"]
      print "скорость ветра #{wind.attributes["max"]} м/c, "
    else
      print "скорость ветра от #{wind.attributes["min"]} до #{wind.attributes["max"]} м/c, "
    end

    print "влажность воздуха #{relwet.attributes["min"]}-#{relwet.attributes["max"]}%\n\n"

    day = "#{days[item.attributes["weekday"].to_i]} (#{item.attributes["day"]} число)"
  end
  user_input = gets.chomp
end
