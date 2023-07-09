require "rexml/document"

def add_to_xml
  puts "What`s product you want to add?"
  puts "1. Mineral"

  user_input = gets.to_i

  if user_input != 1
    exit
  end

  puts "The title of this mineral?" #спрашиваю нужные переменные для отражения их в последующем xml файле

  title = gets.chomp

  puts "Mineral color?"

  color = gets.chomp

  puts "The cost of this item?"

  cost = gets.chomp

  puts "How many items are in stock?"

  stock_item = gets.chomp

  xml_file = File.new(File.dirname(__FILE__ ) + "/data/products.xml")

  xml_document = REXML::Document.new(xml_file)

  product = xml_document.root.add_element("product", "price" => "#{cost}", "stock_item" => "#{stock_item}") #непосредственное добавление в правильном порядке!
  product_element = product.add_element("mineral")
  product_element.add_attribute("title", "#{title}")
  product_element.add_attribute("color", "#{color}")

  file = File.new(xml_file,"w") #запись!
  file.write(xml_document)
  file.close
end