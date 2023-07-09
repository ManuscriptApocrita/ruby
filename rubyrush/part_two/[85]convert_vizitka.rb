#Написать программу, которая конвертирует XML визитку в HTML визитку

require 'rexml/document'

xml_file = File.new((File.dirname(__FILE__) + "/[80]xml_business_card.xml"))

xml_document = REXML::Document.new(xml_file) #читаю уже созданную визитку и беру из неё данные

xml_file.close

root_information = xml_document.root.elements["information"]

name = root_information.attributes["name"] #переменные есть, идем дальше
number = root_information.attributes["number"]
email = root_information.attributes["email"]
about_yourself = root_information.attributes["about_yourself"]

html_document = REXML::Document.new

html_document.add_element("html", {"lang" => "en"})  #элемент, где указывается язык файла

html_document.root.add_element("head").add_element("meta", "charset" => "UTF-8") #элемент, где указывается кодировка файла

body = html_document.root.add_element("body") #далее `тело` html файла с загрузкой набора ранее созданных переменных

body.add_element("p").add_element("img", "src" => "image.jpg") #что интересно, элемент p элемента body выводит с новой строки, а h1 делает заголовок
body.add_element("p").add_text("Name: #{name}")
body.add_element("p").add_text("Number: #{number}")
body.add_element("p").add_text("Email: #{email}")
body.add_element("p").add_text("About yourself: #{about_yourself}")

file = File.new((File.dirname(__FILE__) + "/[109]html_business_card.html"), "w:UTF-8") #создаю файл и ставлю мод - запись

file.puts ("<!DOCTYPE HTML>") #первой строкой файла будет необходимая html-документу строка

html_document.write(file, 2) #запись!

file.close #оптимизация ручным закрытием переменной!



