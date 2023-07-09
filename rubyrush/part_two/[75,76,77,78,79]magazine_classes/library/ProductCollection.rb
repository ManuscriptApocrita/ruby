class ProductCollection #Считыватель данных из папок
  def initialize(products = [])#В инициализации класса входными данными будут продукты, это для self в методе from_dir, иначе не получается
    @products = products
  end

  TYPES_PRODUCTS = {books: {dir: "books", class: Book}, movies: {dir: "movies", class: Movie}} #Постоянная переменная, содержащая папку и соответствующий класс к ней

  def self.from_dir(dir_path) #Можно вызвать метод класса без создания экземпляра класса, т.е ProductCollection.from_dir и сразу будет выполнение
    products = []

    TYPES_PRODUCTS.each do |key, hash| #Прохожу весь хэш, т.е 2 ключа, использую их значения

      iteration_path = hash[:dir] #Папка books/movies
      iteration_class = hash[:class] #Класс Book/Movie

      path_file = "#{dir_path}#{iteration_path}/" #Прокладываю путь к файлу dir_path/book/

      files = Dir.children(path_file) #Беру все названия файлов из папки по указанному пути

      files.each do |item| #Если файл не txt - он удаляется из итогового списка
        if !item.include?(".txt")
          files.delete(item)
        end
      end

      files.each do |item| #Использую названия файлов из папки и пошагово их подставляю в создание соответсвующего экземляра класса
        products << (iteration_class.from_file(path_file + item))
      end
    end

    self.new(products) #Создаю экземпляр класса с продуктами из папок
  end

  def return_array #Возвращает значение переменной @products, т.е продукты
    return @products
  end

  def sorting!(setting) #метод смены порядка продуктов по фиксированным вариантам
     if setting == "by_price"
       @products.sort_by! {|product| product.price} #у классов есть ридеры, которые позволяют смотреть значение и использовать их в сортировке, сначала большее потом меньшее
     elsif setting == "by_stock_item"
       @products.sort_by! {|product| product.stock_item}
     elsif setting == "by_title"
       @products.sort_by! {|product| product.title[0]} #сортировка по первой букве слова, по идее работает
     end
  end
end