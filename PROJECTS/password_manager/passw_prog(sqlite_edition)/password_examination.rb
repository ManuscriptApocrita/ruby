$variations = ["[-        ]", "[- -      ]", "[- - -    ]", "[- - - -  ]", "[- - - - -]"]

def examination_pass(string, size_symbols, size_downcase, size_upcase, size_numbers, min_length) #проверка пароля происходит тут!
  #хотел составить проверку одним регулярным выражением, но по какой-то причине оно не справляется с задачей и работает некорректно, поэтому упрощаю
  #по сути, я ищу соответствие с условием, в каждой проверке я в отедьности регистрирую наличие выполнения условия, и если все совпадают - возвращаю соответствующий результат

  symbols = nil
  if string.scan(/[\/"!#$][%&{|}~'^_`()*+,-.:;<=>?@]/).size >= size_symbols
    symbols = 1
  else
    symbols = 0
  end

  downcase = nil
  if string.scan(/[a-z]/).size >= size_downcase
    downcase = 1
  else
    downcase = 0
  end

  upcase = nil
  if string.scan(/[A-Z]/).size >= size_upcase
    upcase = 1
  else
    upcase = 0
  end

  numbers = nil
  if string.scan(/[0-9]/).size >= size_numbers
    numbers = 1
  else
    numbers = 0
  end

  minimum = nil
  if string.size >= min_length
    minimum = 1
  else
    minimum = 0
  end

  if upcase == 1 && downcase == 1 && symbols == 1 && numbers == 1 && minimum == 1
    result = 1
  else
    result = 0
  end

  return result
end

def upper_or_lower(password, upper, lower) #проверка на количество верхнего или нижнего регистра в пароле!
  password_clear = password.tr("\"[]!#$%&\{|}~'^_`()*+,-./0123456789:;<=>?@ ", "") #тут мне интересны только буквы, остальное очищаю

  #в зависимости от выбора по надобности происходит конкретная проверка, upper = 1 - значит она нужна

  counter = 0
  result = 0

  if upper != 0
    (password_clear.length).times do #по всей длине слова прогоняется вопрос побуквенно - если буква в верхнем регистре - + к результату
      if password_clear[counter].is_upper? #чтобы использовать такие проверки был модифицирован to_s
        result += 1
      end
      counter += 1
    end
  end

  if lower != 0
    (password_clear.length).times do
      if password_clear[counter].is_lower?
        result += 1
      end
      counter += 1
    end
  end

  return result
end

def password_info(password)
  puts "Password: >>  #{password}  <<"
  puts "\nlength - #{password.length}"
  puts "upcase chars - #{upper_or_lower(password, 1, 0)}, downcase chars - #{upper_or_lower(password, 0, 1)}"
  puts "total numbers count - #{password.tr("a-zA-Z\"!#[]$%&\{|}~'^_`()*+,-./:;<=>?@ ", "").size}"
  puts "total symbols count - #{password.tr("a-zA-Z0-9 ", "").size}"
  puts coincidence(password, 0)
end

def coincidence(password, check) #поиск повторяющихся знаков, символов, букв

  counter = 0
  coincidence_x2 = 0

  (password.size / 2).times do

    one_letter = password[counter]
    counter += 1

    two_letter = password[counter]
    counter += 1

    if one_letter == two_letter
      coincidence_x2 += 1
    end
  end

  if check == 1
    return coincidence_x2
  end

  if coincidence_x2 > 0
    puts "two identical characters in sequence (total): #{coincidence_x2}"
  else
    puts "coincidences (two identical characters in sequence) not found!"
  end
end

def security_password_check

  system("cls") || system("clear")

  loop do

    puts "\nInput your password for check it"

    password = gets.chomp

    while
      if password == "exit"
        return
      elsif password.length > 35 || password.empty?
        puts "Input correct answer..."
        password = gets.chomp
      else
        break
      end
    end

    if password.size <= 6
      system("cls") || system("clear")
      puts "Password: #{password}"
      puts "#{$variations[0].colorize(31)} you have 1 lvl of security because password length - #{password.length}"
    else
      if examination_pass(password, 2,2, 2, 2, 17) == 1 && coincidence(password, 1) < 3
        system("cls") || system("clear")
        password_info(password)
        puts "#{$variations[4].colorize(32)} you have MAX lvl of security"
      elsif examination_pass(password, 2, 2, 2, 0, 14) == 1 && coincidence(password, 1) < 6
        system("cls") || system("clear")
        password_info(password)
        puts "#{$variations[3].colorize(36)} you have 4 lvl of security"
      elsif examination_pass(password, 1, 2, 2, 1, 11) == 1
        system("cls") || system("clear")
        password_info(password)
        puts "#{$variations[2].colorize(33)} you have 3 lvl of security"
      elsif examination_pass(password, 0, 1, 1, 1, 9) == 1
        system("cls") || system("clear")
        password_info(password)
        puts "#{$variations[1].colorize(35)} you have 2 lvl of security"
      else
        system("cls") || system("clear")
        puts "Password: #{password}"
        puts "#{$variations[0].colorize(31)} you have 1 lvl of security"
      end
    end
  end
end