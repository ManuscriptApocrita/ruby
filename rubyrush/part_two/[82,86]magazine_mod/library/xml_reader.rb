require "rexml/document"

def read_xml(path) #чтение товаров их xml!!
  unless File.exist?(path) #если файла не нашлось - сообщение
    abort "File not found..."
  end

  file = File.new(path)
  xml_document = REXML::Document.new(file)
  file.close

  result = [] #переменные обозначены до входа в переборку элементов xml документа, чтобы они были доступны по всему методу
  product = nil

  xml_document.elements.each("products/product") do |element| #пробегаюсь по корневым элементам, беру от них нужные аттрибуты
    price = element.attributes["price"]
    stock_item = element.attributes["stock_item"]

    element.each_element("mineral") do |mineral_item| #тут элемент в элементе, в нём так же есть нужные данные, присваиваю их куда нужно
      product = Mineral.new(price, stock_item)
      product.update("title" => mineral_item.attributes["title"], "color" => mineral_item.attributes["color"])
    end
    result << product
  end
    return result
  end