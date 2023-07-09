#Сделать программу-магазин и научить его считывать данные из xml файла
#дописать к магазину программу, которая будет записывать новый товар в xml
# список товаров. Программа спрашивает у пользователя, какой продукт он хочет
# добавить и в зависимости от выбора просит у него дополнительно ввести
# соответствующие поля

require_relative "library/products"
require_relative "library/minerals"
require_relative "library/xml_reader"
require_relative "add_product"

$products = read_xml(File.dirname(__FILE__) + "/data/products.xml") #читаю из папки xml файл и загружаю в переменную

price = 0

# add_to_xml

def print_method(price) #метод печати данных о товарах магазина
  puts "What you want to buy?"
  $products.each_with_index do |item, index| # сама печать, берется из информации о классах
    if $products[index].stock_item.to_i > 0 #проверка, если количество на склада закончилось - товар не выводится и его цена становится ноль, чтобы не было повышение цены на несуществующий товар
      puts "#{index + 1}: #{item.information}"
    else
      $products[index].price = 0
    end
  end
  puts "WriteRead exit to exit the program!"
  puts "\nYour price for buy - #{price}" if price != 0

end

print_method(price)

while

  user_input = gets.chomp
  system("cls") || system("clear")

  if user_input.to_i <= $products.size && user_input.to_i > 0 #если введенное пользователем число в диапазоне приведенных товаров - допускается ответ
    $products[user_input.to_i - 1].stock_item = ($products[user_input.to_i - 1].stock_item.to_i - 1) #отнимаю от количества на складе единицу товара
    price = price + ($products[user_input.to_i - 1].price).to_i #прибавляю к переменной цены за покупки переменную цены товара
    print_method(price)
  elsif user_input == "exit"
    exit
  else
    print_method(price)
    puts
    puts "This product index does not exist"
  end

end


