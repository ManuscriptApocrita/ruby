#Объявить переменную variable, после чего объявить класс MyClass и написать у
#него конструктор, который создаёт переменную экземпляра @variable
#Потом написать у класса метод check_variables, который проверяет объявлены ли переменные variable и @variable
#В основной программе создать экземпляр класса MyClass и вызвать у него метод check_variables, а потом проверить
#объявленность тех же переменных в основном тексте программы.

variable = 0

class CommonClass
  def initialize
    @variable = 1
  end

  def checking
    puts "In class..."
    if defined?(@variable)
      puts "Variable \"@variable\" declared" #про способ с дробью на вывод обычных кавычек не знал
    else
      puts "Variable \"@variable\" not declared"
    end

    if defined?(variable)
      puts "Variable \"variable\" declared"
    else
      puts "Variable \"variable\" not declared"
    end
  end
end

exemplar_class = CommonClass.new

exemplar_class.checking

puts
puts "Out class..."

if defined?(@variable)
  puts "Variable \"@variable\" declared"
else
  puts "Variable \"@variable\" not declared"
end

if defined?(variable)
  puts "Variable \"variable\" declared"
else
  puts "Variable \"variable\" not declared"
end
