class Storage #класс - результат инкапсуляции
  def initialize(toys, notebooks)
    @toys = toys
    @notebooks = notebooks
  end

  attr_reader :toys, :notebooks

  def examine_variable(variable)
    if variable < 0 || variable.is_a?(Integer) == false
      false
    else
      true
    end
  end

  private :examine_variable #здесь применяется сокрытие метода, видимость - только в классе

  def change_value(name, value)
    case name
    when "toys"
      if examine_variable(value)
        @toys = value
      end
    when "notebooks"
      if examine_variable(value)
        @notebooks = value
      end
    else
      nil
    end
  end
end

aaron_shop = Storage.new(10, 15)

puts "Toys in SHOP - #{aaron_shop.toys}"
puts "Notebooks in SHOP - #{aaron_shop.notebooks}"

aaron_shop.change_value("toys", 1) #проверка будет пройдена и переменная класса изменится
aaron_shop.change_value("toys", -10) #переменная не изменится, потому что входные данные не прошли проверку
aaron_shop.change_value("toyz", 3) #не изменится, и, что важно, не будет ошибки
aaron_shop.change_value("notebooks", 1)
aaron_shop.change_value("notebooks", -10)
aaron_shop.change_value("notebookz", 3)

#использование метода change_value наглядно демонстрирует использование результата инкапсуляции,
# и этот же метод использует сокрытие, что позволяет, в этом случае, обеспечить безопасность данных

puts "\nToys in SHOP after change - #{aaron_shop.toys}"
puts "Notebooks in SHOP after change - #{aaron_shop.notebooks}"

# shop_one.examine_variable(1) вызов метода не сработает, его область видимости - только класс