#Сделать свою визитку в формате XML. Указать данные о себе. Потом написать программу, которая читает эту визитку
# в формате xml и выводит в консоли информацию красиво

require "rexml/document"

file_path = (File.dirname(__FILE__)) + "/[80]xml_business_card.xml" #указываю путь до файла

unless File.exist?(file_path) #если файла нету - сообщаю об этом
  abort "File not found!"
end

file = File.new(file_path)

xml_document = REXML::Document.new(file)

file.close

xml_document.elements.each("business_card/information") do |element| #перебираю известную структуру xml, и использую аттрибуты элемента корневого каталога
  puts "Full name: #{element.attributes["name"]}"
  puts "Contact information: #{element.attributes["number"]}, #{element.attributes["email"]}"
  puts "About yourself: #{element.attributes["about_yourself"]}"
end