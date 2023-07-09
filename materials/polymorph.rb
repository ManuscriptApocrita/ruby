class Auto #Класс "Авто" имеет абстрактное значение и может изменять форму реализации от машины к машине, но есть и устойчивые характеристики
  def initialize(weight, body_type)
    @weight = weight
    @body_type = body_type
  end

  def can_accelerate_200?(value)
    if value >= 200
      puts "This car can accelerate to 200 kph"
    end
  end
end

class BMW < Auto #Тут находится пример полиморфизма, то есть изменение формы реализации. От абстрактного к конкретному. Форма меняется конкретной машиной и её данными.
  def initialize(model, weight, body_type, max_speed, sales_start_year)
    super(weight, body_type)
    @model = model
    @max_speed = max_speed
    @sales_start_year = sales_start_year
  end

  def can_accelerate_200?
    super(@max_speed)
  end

  def general_info
    puts "MODEL: #{@model}\nMAX SPEED: #{@max_speed}\nBODY TYPE: #{@body_type}\nWEIGHT: #{@weight}\nSALES START YEAR: #{@sales_start_year}"
  end
end

bmw = BMW.new("M3 (F80)","2.1 tons", "sedan", 250, 2014)

bmw.general_info
bmw.can_accelerate_200?