#1. Найти в интернете способ выяснить объявлена ли переменная,
#и написать программу, которая пишет, объявлены ли переменные a и b.
#Затем объявить переменную a и запустить программу.
#2.Объявить три переменных: Глобальную переменную $a ; Локальную переменную b; Переменную c внутри метода method
#Проверить объявлена ли каждая из них: внутри метода и в основном тексте программы.

# b = "Crocodile"

# if defined? b #Прикольный метод
#   puts "Variable `b` declared"
# else
#   puts "Variable `b` not declared"
# end

# if defined? a
#   puts "Variable `a` declared"
# else
#   puts "Variable `a` not declared"
# end

$a = 0
b = 0

def method
  c = 14
  $k = 1
  puts "Variable in method '$a': #{defined?$a}"
  puts "Variable in method 'b': #{defined?b}"
  puts "Variable in method 'c': #{defined?c}"
  puts

end

method
puts $k

puts "Variable '$a': #{defined?$a}"
puts "Variable 'b': #{defined?b}"
puts "Variable 'c': #{defined?c}"

#исходя из наблюдений - переменные метода доступны только в методе, если я их назначу локальными.
# но можно объявить глобальную переменную в методе и она будет доступна по всей программе