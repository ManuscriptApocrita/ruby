class Mineral < Products #класс минерал дочерний от класса продукты
  def update(setting)
    @title = setting["title"]
    @color = setting["color"]
  end

  def information
    "Mineral #{@title}, color - #{@color}, #{super}" #super добавляет остаточные данные, т.е переменные инициализации класса `продукты`
  end
end
