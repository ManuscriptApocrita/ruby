#1. Написать заготовку для небольшого магазинчика, который торгует фильмами и книгами.
#Создать класс продукта, у экземпляров которого есть два поля: цена и количество на складе.
#При создании нового продукта можно передать значения цены и остатка.
#Для этих переменных сделать геттеры. Унаследовать от этого класса два других: книгу и фильм
#соответственно. Своих переменных у этих классов пока нет. Создать в основной программе
#какой-нибудь продукт, например «фильм Леон». Вывести его стоимость в консоль.
#2. Дописать методы для изменения классов Book и Film. Добавить возможность поменять внутреннюю переменную экземпляра
#3. Реализовать функционал считывания продуктов из папки data. Написать для каждого класса-ребенка метод класса, который создает
# новый экземпляр класса, заполняя данными из файла. Так же добавить, чтобы метод родителя возвращал ошибку NotImplementedError
# на случай, если какой-то ребенок попытается создать себя используя метод родителя
#4. Реализовать класс ProductCollection, который может хранить в себе любые товары (фильмы и книги) и у которого есть:
# метод класса from_dir, который считывает продукты из папки data, сам понимая, какие товары в какой папки лежат. Метод
# экземпляра to_a, который возвращает массив товаров. Метод экземпляра sort, который сортирует товары по цене, остатку на складе
# или по названию (по возрастанию и убыванию). Создать в основной программе коллекцию товаров, прочитав её из директории и вывести все
# товары на экран

require_relative "library/product"
require_relative "library/movie"
require_relative "library/book"
require_relative "library/ProductCollection"

products = []

products << Movie.new(title: "Jaws", year: "1975", director: "Stiven Spilberg", price: "330", stock_item: "2")
products << Book.new(title: "Strength training anatomy", genre: "??", year: "2005", author: "Phrederik Delavie", price: "750", stock_item: "4")

for item in products
  puts item.to_s
end

movie = Movie.new(title: 'Batman', director: 'Ein Mann', stock_item: 4)
movie.year = "2013"
movie.update(title: 'Batman: Arkham Night', price: 1500)
puts movie.to_s

new_movie = Movie.from_file(File.dirname(__FILE__) + "/data/movies/01.txt")
new_book = Book.from_file(File.dirname(__FILE__) + "/data/books/01.txt")

puts new_movie.to_s
puts new_book.to_s

collection = ProductCollection.from_dir(File.dirname(__FILE__) + "/data/")

collection.return_array.each do |item|
  puts item.to_s
end

collection.sorting!("by_title")

collection.return_array.each do |item|
  puts item.to_s
end