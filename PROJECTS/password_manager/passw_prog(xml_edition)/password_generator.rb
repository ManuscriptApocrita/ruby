#~!@#$%^&*()+`'";:<>/\|
class Password_generator
  def initialize
    super
    @lowercase = ["j", "d", "n", "i", "q", "v", "u", "k", "m", "f", "b", "z", "s", "x", "o", "y", "h", "a", "e", "c", "r", "w", "t", "p", "g", "l"] #- Наборы символов, цифр, букв для шифрования
    @uppercase = ["U", "K", "W", "Q", "N", "O", "B", "M", "V", "T", "L", "G", "X", "C", "S", "D", "H", "J", "P", "Y", "R", "Z", "I", "A", "F", "E"]
    @numbers = ["9", "6", "8", "0", "5", "2", "7", "1", "4", "3"]
    @symbols = ["!", "#", "$", "%", "*", "(", ")", "+"]
    @word_storage = Array.new #- понадобится для складирования слов мнемонической генерации
    @array = Array.new #- символы пароля
    @words = nil #- большое количество слов для мнемонического пароля
    @loading = nil #- сюда загружается псевдографика из файла
  end

  attr_reader :lowercase, :uppercase, :numbers

  def loading #имитация загрузки псевдографикой, каждый раз время на загрузку каждый раз случайное
    puts @loading[0]
    puts @loading[(rand(1...2))]
    sleep(rand(2))
    system("cls") || system("clear")
    puts @loading[0]
    puts @loading[(rand(3...4))]
    sleep(rand(2))
    system("cls") || system("clear")
    puts @loading[0]
    puts @loading[(rand(5...6))]
    sleep(rand(2))
    system("cls") || system("clear")
    puts @loading[0]
    puts @loading[(rand(7...9))]
    sleep(rand(2))
    system("cls") || system("clear")
    puts @loading[0]
    puts @loading[10]
    puts "End of response processing!"
    puts
    sleep(1)
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
    @array.clear #так как пользователь может повторить генерацию - каждый раз нужно обнулять переменные, куда загружается результат генерации
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
      @array << word[0] #добавляю первую букву слова
      @array << word[1].capitalize #добавляю вторую букву слова верхнего регистра в результирующий массив
      counter += 1
    end

    @array = @array << ["3!6"] #оговоренное в readme значение, которое добавляется ко всем мнемо-паролям

    loading #вызываю метод псевдозагрузки

    puts "Word list - #{@word_storage[0...$user_input].join(" ")}" #показываю результат
    puts "Generation result: #{@array.join("")}\n\n"

    puts "Press enter to save, write `next` to regenerate..." #предлагаю сохранить или повторить генерацию по новой

    user_input = gets.chomp

    while
      if user_input.empty?
        break
      else
        if user_input == "next"
          word_password
        end
        puts "Input correct answer!"
        user_input = gets.chomp
      end
    end

    system("cls") || system("clear")

    puts "Input login of this password:" #в дальнейшем свяжу ввод пользователя с остальными данными генерации

    comment = gets.chomp

    while #пользователю нужно написать хоть что-то
      if comment.empty?
        puts "Please, don`t forgot add login..."
        comment = gets.chomp
      else
        break
      end
    end

    security_manager = Security_manager.new #передаю данные в метод шифровки и сохранения
    security_manager.encryption(@array, comment, @word_storage)
  end

  def randomize_password #метод генерации случайного пароля
    system("cls") || system("clear")

    puts "Enter the desired password length (minimum 5):"
    $user_input = gets.to_i

    while #Проверка на ввод
      if $user_input != 0 && $user_input <= 35 && $user_input >= 5
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

    # $user_input.times do #пароль формируется из верхнего и нижнего регистра (50 на 50) | ранее используемый метод генерации
    #   if rand(2) == 1
    #     @array << (@lowercase + @numbers + @symbols).sample.capitalize
    #   else
    #     @array << (@lowercase + @numbers + @symbols).sample.downcase
    #   end
    # end

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
        end
        puts "Input correct answer!"
        user_input = gets.chomp
      end
    end

    system("cls") || system("clear")
    puts "Input login of this password:"

    comment = gets.chomp

    while #пользователю нужно написать хоть что-то
      if comment.empty?
        puts "Please, don`t forgot add login..."
        comment = gets.chomp
      else
        break
      end
    end

    password = password.split(", ")

    security_manager = Security_manager.new #отправляю дальше, если все проверки пройдены
    security_manager.encryption(password, comment, [])
  end

  def add_manually #метод ручного добавления связки пароль-логин
    system("cls") || system("clear")

    puts "Input your password"
    password = gets.chomp

    while #пользователю нужно написать хоть что-то
      if password.empty?
        puts "Please, don`t forgot add password..."
        password = gets.chomp
      else
        break
      end
    end

    system("cls") || system("clear")

    puts "Input your login:"

    login = gets.chomp

    while
      if login.empty?
        puts "Please, don`t forgot add login..."
        login = gets.chomp
      else
        break
      end
    end

    password = password.split(", ")

    security_manager = Security_manager.new #отправляю дальше, если все проверки пройдены
    security_manager.encryption(password, login, [])
  end

end
