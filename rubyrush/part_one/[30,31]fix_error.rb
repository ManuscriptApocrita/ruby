#1. Исправить ошибку в демонстрационной программе
#В методе sklonenie есть один баг (ошибка) — он неправильно работает с числами от 11 до 14.
#Например, вместо 11 негритят он вернет 11 негритенок, а вместо 14 негритят — 14 негритенка.
#2. В методе sklonenie есть еще один баг (сможете ли найти его самостоятельно?).
#Попробуйте ввести 112, вместо 112 негритят метод вернет 112 негритенка.
#Исправьте и эту ошибку в методе sklonenie.

# def sklonenie(number, krokodil, krokodila, krokodilov)
#   if number == nil || !number.is_a?(Numeric)
#     number = 0
#   end

#   if number >= 11 && number <= 14
#     return krokodilov
#   end
  
# end

# skolko = ARGV[0].to_i

# puts "#{skolko} #{sklonenie(skolko, 'негритёнок', 'негритёнка', 'негритят')} " \
#   "#{sklonenie(skolko, 'пошел', 'пошли', 'пошли')} купаться в море!"


def sklonenie(number, krokodil, krokodila, krokodilov)
  if number == nil || !number.is_a?(Numeric)
    number = 0
  end

  ostatok100 = number % 100

  if (ostatok100 >= 11 && ostatok100 <= 14)
    return krokodilov
  end
  
end

skolko = ARGV[0].to_i

puts "#{skolko} #{sklonenie(skolko, 'негритёнок', 'негритёнка', 'негритят')} " \
  "#{sklonenie(skolko, 'пошел', 'пошли', 'пошли')} купаться в море!"