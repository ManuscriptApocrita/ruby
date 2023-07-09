require "securerandom" #библиотека безопасного рандома :D ранее использовал обычный, но пусть будет этот, звучит надежнее

#~!@#$%^&*()+`'";:<>/\|
class Password_generator
  def initialize
    super
    @lowercase = %w[f a e b m i s z t g h n r x v k o y p w d q u l c j] #- Наборы символов, цифр, букв для шифрования
    @uppercase = %w[A Q M J F U Y R X W H D E V K C O N P S I G L B Z T]
    @numbers = %w[5 0 9 2 3 1 6 7 8 4]
    @symbols = %w[! # $ % * ( ) +]
    @word_storage = Array.new #- понадобится для складирования слов мнемонической генерации
    @password_symbols = Array.new #- символы пароля
    @words = nil #- большое количество слов для мнемонического пароля
    @loading = nil #- сюда загружается псевдографика из файла
  end

  attr_reader :lowercase, :uppercase, :numbers

  def loading #имитация загрузки псевдографикой, каждый раз время на загрузку случайное
    n = 1

    loop do
      system("cls") || system("clear")
      puts @loading[0]

      if n <= 6
        puts @loading[(rand(n..n + 1))]
      else
        break
      end

      n += 1
      sleep(rand(2))
    end

    system("cls") || system("clear")
    puts @loading[0]
    puts @loading[10]
    puts "End of response processing!"
    puts
    sleep(0.5)
  end

  def files_initialize #тут подгружаются файлы, содержащие слова и псевдографику
    begin #Если файлы не нашлись - работа программы завершается
      words_file = File.new("data/words.txt")
      loading_file = File.new("data/loading.txt")
      @words = words_file.readlines
      @loading = loading_file.readlines
      words_file.close
      loading_file.close
    rescue
      puts "Need files not found!"
      sleep(2)
      exit
    end
  end

  def word_password #метод генерации пароля мнемонического типа
    $login = nil
    $comment = nil

    @password_symbols.clear #так как пользователь может повторить генерацию - каждый раз нужно обнулять переменные, куда загружается результат генерации
    @word_storage.clear

    system("cls") || system("clear")
    puts "Enter how many words will be used in the password (minimum 2): "

    $user_input = gets.to_i

    while
      if $user_input != 0 && $user_input >= 2 && $user_input <= 15
        break
      else
        puts "Input correct answer..."
        $user_input = gets.to_i
      end
    end

    counter = 0

    $user_input.times do #непосредственная генерация, опирается на выбранное количество слов пользователем
      @word_storage << @words.sample.chomp.downcase #в хранилище слов добавляю случайное слово, выбранное из базы слов
      word = @word_storage[counter] #выбираю загруженное слово по его порядку, нужен порядок, так как слов будет больше одного
      word.split(", ") #превращаю переменную на массив
      @password_symbols << word[0] #добавляю первую букву слова
      @password_symbols << word[1].capitalize #добавляю вторую букву слова верхнего регистра в результирующий массив
      counter += 1
    end

    @password_symbols = @password_symbols << ["3!6"] #оговоренное в readme значение, которое добавляется ко всем мнемо-паролям

    loading #вызываю метод псевдозагрузки

    puts "Word list - #{@word_storage[0...$user_input].join(" ")}" #показываю результат
    puts "Generation result: #{@password_symbols.join("")}\n\n"

    puts "Press enter to save, write `next` to regenerate..." #предлагаю сохранить или повторить генерацию по новой

    user_input = gets.chomp

    while
      if user_input.empty?
        break
      else
        if user_input == "next"
          word_password
        else
          puts "Input correct answer!"
          user_input = gets.chomp
        end
      end
    end

    question_input_data(0)

    add_to_base = Security_manager.new
    add_to_base.encryption($login, @password_symbols, $comment, @word_storage)
  end

  def randomize_password #метод генерации случайного пароля

    system("cls") || system("clear")

    puts "Enter the desired password length (minimum 5):"
    $user_input = gets.to_i

    while #Проверка на ввод
      if $user_input != 0 && $user_input <= 35 && $user_input >= 6
        break
      else
        puts "Input correct answer..."
        $user_input = gets.to_i
      end
    end

    $char_num_sym = (@lowercase + @uppercase + @numbers + @symbols)

    password = ""

    $user_input.times do
      password = password << $char_num_sym[SecureRandom.random_number($char_num_sym.size)]
    end

    loading #декоративная загрузка

    puts "Generation result: #{password}\n\n"

    puts "If you want save this, press enter. If you want next - write next"

    user_input = gets.chomp

    while
      if user_input.empty?
        break
      else
        if user_input == "next"
          randomize_password
        else
          puts "Input correct answer!"
          user_input = gets.chomp
        end
      end
    end

    question_input_data(0)

    password = password.split(", ")

    add_to_base = Security_manager.new
    add_to_base.encryption($login, password, $comment, [])
  end

  def add_manually #метод ручного добавления связки пароль-логин

    question_input_data(1)

    $password = $password.split(", ")

    add_to_base = Security_manager.new
    add_to_base.encryption($login, $password, $comment, [])
  end

  def question_input_data(manually)
    $login = nil
    $password = nil
    $comment = nil

    if manually == 1
      system("cls") || system("clear")

      puts "Input your login:"
      $login = gets.chomp

      while
        if $login.empty?
          puts "Please, don`t forgot add login..."
          $login = gets.chomp
        else
          break
        end
      end

      system("cls") || system("clear")

      puts "Input your password:"
      $password = gets.chomp

      while #пользователю нужно написать хоть что-то
        if $password.empty?
          puts "Please, don`t forgot add password..."
          $password = gets.chomp
        else
          break
        end
      end

      system("cls") || system("clear")

      puts "Input comment of this password:"
      $comment = gets.chomp

      while #пользователю нужно написать хоть что-то
        if $comment.empty?
          puts "Please, don`t forgot add comment..."
          $comment = gets.chomp
        else
          break
        end
      end

    else
      system("cls") || system("clear")

      puts "Input your login:"
      $login = gets.chomp

      while
        if $login.empty?
          puts "Please, don`t forgot add login..."
          $login = gets.chomp
        else
          break
        end
      end

      system("cls") || system("clear")

      puts "Input comment of this password:"
      $comment = gets.chomp

      while #пользователю нужно написать хоть что-то
        if $comment.empty?
          puts "Please, don`t forgot add login..."
          $login = gets.chomp
        else
          break
        end
      end
    end
  end

end
