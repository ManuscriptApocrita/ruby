class Product
  def initialize(setting)
     @price = setting[:price]
     @stock_item = setting[:stock_item]
  end

  attr_reader :price, :stock_item #Позволяет прочитать переменные
  attr_accessor :price, :stock_item #Позволяет записать переменные

  def update(setting) #метод смены значения переменной инициализации с помощью метода
    @price = setting[:price] if setting[:price]
    @stock_item = setting[:stock_item] if setting[:stock_item]
  end

  def to_s
    "#{@price} rubles (stock item: #{@stock_item})"
  end

  def self.from_file(file_path) #создать Product.from_file не получится, в случае попытки вернется ошибка
    raise NotImplementedError
  end
end
