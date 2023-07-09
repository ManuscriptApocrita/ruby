#Написать программу, которая показывает текущие курсы волют

require "net/http"
require "rexml/document"

url = URI.parse("http://www.cbr.ru/scripts/XML_daily.asp")

request = Net::HTTP.get_response(url)

xml_document = REXML::Document.new(request.body)

dollar_value = 0
eur_value = 0

xml_document.root.elements.each do |item| #в цикле забираю нужные данные
  if item.attributes["ID"] == "R01235"
    dollar_value = item.elements["Value"].text
  end

  if item.attributes["ID"] == "R01239"
    eur_value = item.elements["Value"].text
  end
end

if dollar_value.to_i > 90 # :D
  dollar_text = "рублей :O (это не ошибка?) :O"
elsif eur_value.to_i > 90
  eur_text = "рублей (это не ошибка?) :O"
else
  dollar_text = "рублей "
  eur_text = "рублей"
end


puts "Стоимость иностранной валюты (за штуку):"
puts "Доллар США - #{dollar_value} #{dollar_text}"
puts "Евро - #{eur_value} #{eur_text}"