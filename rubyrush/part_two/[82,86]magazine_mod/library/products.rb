class Products
  def initialize(price, stock_item)
    @price = price
    @stock_item = stock_item
  end

  attr_reader :price, :stock_item
  attr_accessor :price, :stock_item

  def information
    "price #{@price}, stock_item - #{@stock_item}"
  end

  def update(setting) #метод изменения переменных инициализации класса
    @price = setting["price"] if setting["price"]
    @stock_item = setting["stock_item"] if setting["stock_item"]
  end
end

