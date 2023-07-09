class Game
  def initialize
    @colors_array = { 1 => 31, 2 => 32, 3 => 33, 4 => 34 } #Хэш-набор используемых цвето-кодов для текста
    @arrows = ["←", "↑", "→", "↓"] #Массив стрелок, используемых в генерации задачи пользователю
    @array = [] #Массив накопления символов для повторения пользователем
    @points = 0 #Поинты для определения стадии игры, совместно используется как достижение пользователя
    @mistakes = 0 #Совершенные ошибки в ходе игры
  end

  $duration = 16 #Используется в продолжении игры на высшем уровне, начальное значение сложилось из самого высокого значения символьной длительности в прошлых уровнях + 2
  $time = 9 #Используется в продолжении игры на высшем уровне, начальное значение сложилось из самого высокого значения времени в прошлых уровнях + 1
  $start_time = Time.now #Фиксация времени начала игры

  def common_level(text, time_task, duration) #Шаблон обычного уровня с изменением ключевых параметров
    puts text
    $time_task = Time.now + time_task
    duration.times do
      @array << @arrows.sample
    end
  end

  def advanced_level(text, time_task, duration) #Шаблон продвинутого уровня с изменением ключевых параметров
    puts text
    $time_task = Time.now + time_task
    duration.times do
      if rand(2) == 1
        @array << "⚫".colorize(@colors_array.values.sample)
      else
        @array << @arrows.sample
      end
    end
  end

  def level_system #Система уровней, в которой используются шаблоны уровней, опираясь на очки
    if @points <= 6
      common_level("1 level!", 2.5, 3)
    elsif @points >= 7 && @points <= 13
      common_level("2 level!", 3.5, 5)
    elsif @points >= 14 && @points <= 20
      common_level("3 level!", 4.5, 7)
    elsif @points >= 21 && @points <= 27
      common_level("4 level!", 5.5, 9)
    elsif @points >= 28 && @points <= 34
      advanced_level("5 level! | ADVANCED-mastery", 4, 5)
    elsif @points >= 35 && @points <= 41
      advanced_level("6 level!", 6, 8)
    elsif @points >= 42 && @points <= 48
      advanced_level("7 level!", 7, 11)
    elsif @points >= 49 && @points <= 55
      advanced_level("8 level!", 8, 14)
    elsif @points >= 56 #Ранее в методе использовались конкретные параметры шаблонных уровней, теперь же они изменяемы в зависимости от того, пройдёт ли пользователь очередной уровень. Сложность идёт по экспоненте
      advanced_level("MARVELOUS!!!", $time, $duration)
      $duration += 2
      $time += 1
    end
  end

  def win
    system("cls") || system("clear")
    puts "Congratulations, you have completed the game!" #Если выход из предыдущего цикла состоялся - значит пользователь ударился в планку, установленную под победу
    puts
    puts "Game statistics:"
    puts "points - #{@points}"
    puts "mistakes - #{@mistakes}"
    puts "elapsed time - #{($start_time - Time.now).abs.round(1)} seconds"
    puts "BONUS"
    puts(
    "▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒███▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒█▓▓█▒██▓▓▓██▒█▓▓█▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒█▓▒▒▓█▓▓▓▓▓▓▓█▓▒▒▓█▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒█▓▒▒▓▓▓▓▓▓▓▓▓▓▓▒▒▓█▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▓▓▓▓▓▓▓▓▓█▒▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒▒█▓▓█▓▓▓▓▓▓█▓▓▓█▒▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒▒█▓▓██▓▓▓▓▓██▓▓█▒▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▒▒█▓█▒▒▓▓▓▓█▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒█▓▓▒▒▓▒▒███▒▒▓▒▒▓▓█▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒█▓▓▒▒▓▒▒▒█▒▒▒▓▒▒▓▓█▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▓▓▒▒▒▒▒▓▓▓▓▓▓█▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▓▓███▓▓▓▓▓▓█▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▓▓▓▓▓▓▓▓▓█▒▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▒▒▒▒▒▒▒▓▓▓▓█▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▒▒▒▒▒▒▒▒▒▓▓▓▓█▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒█▓▓▓█▓▒▒▒▒▒▒▒▒▒▓█▓▓▓█▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒██▓▓▓█▓▒▒▒██▒██▒▒▒▓█▓▓▓██▒▒▒▒▒▒▒
     ▒▒▒▒▒▒█▓▓▓▓█▓▓▒▒█▓▓█▓▓█▒▒▓▓█▓▓▓▓█▒▒▒▒▒▒
     ▒▒▒▒▒█▓██▓▓█▓▒▒▒█▓▓▓▓▓█▒▒▒▓█▓▓██▓█▒▒▒▒▒
     ▒▒▒▒▒█▓▓▓▓█▓▓▒▒▒▒█▓▓▓█▒▒▒▒▓▓█▓▓▓▓█▒▒▒▒▒
     ▒▒▒▒▒▒█▓▓▓█▓▓▒▒▒▒▒█▓█▒▒▒▒▒▓▓█▓▓▓█▒▒▒▒▒▒
     ▒▒▒▒▒▒▒████▓▓▒▒▒▒▒▒█▒▒▒▒▒▒▓▓████▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒█▓▓▓▒▒▒▒▒▒▒▒▒▒▒▓▓▓█▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▒▒▒▒▒▒▒▒▒▓▓▓█▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▒▒▒▒▒▒▒▓▓▓▓█▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▓█▓█▓▓▓▓▓█▒▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▓█▓▓▓▓▓█▒▒▒▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒▒████▓▓▓▓▓█▓▓▓▓▓████▒▒▒▒▒▒▒▒▒▒
     ▒▒▒▒▒▒▒▒▒█▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓█▒▒▒▒")
    puts "The game will close in a minute"
    sleep(60)
    exit
  end

  def defeat
    system("cls") || system("clear")
    puts "Oops, in-game time is over!"
    puts "Game statistics:"
    puts "points - #{@points}"
    puts "mistakes - #{@mistakes}"
    puts "elapsed time - #{($start_time - Time.now).abs.round(1)} seconds"
    puts
    puts "To continue the game, press enter, to exit - write exit."
    while user_input = gets.chomp #Предусмотрена возможность выхода из приложения и продолжения игры с чистого листа
      if user_input.downcase == "exit"
        exit
      elsif user_input.empty?
        $duration = 16
        $time = 9
        @array = []
        @points = 0
        @mistakes = 0
        sleep(2)
        $start_time = Time.now
        circle_arrow_game
      end
    end
  end

  def examination(user_input) #Проверка введённого пользователем ответа

    system("cls") || system("clear")

    case user_input #Момент преобразования введённого пользователем в то, с чем может дальше работать программа
    when "w" then user_input = "↑"
    when "a" then user_input = "←"
    when "s" then user_input = "↓"
    when "d" then user_input = "→"
    when "r" then user_input = "⚫".colorize(31)
    when "g" then user_input = "⚫".colorize(32)
    when "y" then user_input = "⚫".colorize(33)
    when "b" then user_input = "⚫".colorize(34)
    when ""
      user_input = "error"
    end

    case when @array[0].include?(user_input) #Если введённое пользователем есть в первом символе массива - символ массива удаляется
           @array.delete_at(0)
    else
      @mistakes += 1 #В случае, если нету - плюс единица к числу ошибок пользователя
      if @points > 0 #Если есть что отнимать от очков - они отнимаются на 1 и показываются оставшиеся очки
        @points -= 1
        puts "Wrong answer, you lost 2 points... Remaining points: #{@points}"
      elsif @points < 0 #Отнимать нечего - значит и забирать незачем
        puts "Wrong answer..."
      end
    end
  end

  def print_status #Печать в консоль статуса игры
    time_info = $time_task - Time.now #Проверка разницы переменных времени, данного на задачу, и настоящего времени

    if time_info < 0 #Если время ушло в отрицательный диапазон - время вышло, а игра окончена
      defeat
    end

    puts "Solve the sequence. Time left: #{time_info.round(2)}" #Вывод оставшегося времени, округленного до двух чисел после запятой
    puts
    puts @array.join(" ") #Вывод массива, который ранее в себя набрал разные символы
    puts
  end

  def circle_arrow_game #Метод самой игры

    while @points <= 55 #Вход в цикл, опираясь на очки - шапка игры 55 поинтов, и она пройдена

      level_system #Вызов метода системы уровней
        loop do
          break if @array.length == 0 #Если выход из цикла состоялся - значит пользователь справился с последовательностью символов успешно - пользователь победил в итерации
          user_input = ""
          print_status
          char = STDIN.getch.downcase.to_s
          user_input += char
          examination(user_input)
          user_input.clear
        end

      @points += 3 #Начисляю поинты, чтобы уровень скалировался
      puts "Win! 3 points added. Your points: #{@points}"
    end #Если из цикла пользователь вышел - он набрал 56 очков или более - победа
    win
  end
end