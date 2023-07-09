class GTW
  def initialize #Создаю нужные переменные
    @uncorrect_letters = Array.new
    @correct_letters = Array.new
    @word = String.new
    @hints = 0
    @status = 0
    @counter = 1
    @image_status = []
    @error_counter = 0
    files_initialize
    system('cls') || system('clear')
  end

  attr_reader :word

  def begin_gtw
    puts "The game: <Guess the word>, version 1.4" #Знакомлю с правилами
    puts "\nRules: You have 5 attempts to guess the word by entering letters."
    puts "You have two clue, a random letter from the word will open when writing <hint>."
    puts "\nStart a game? Press enter"

    user_input = gets.chomp

    if user_input.empty?

      while @status == 0 #Если статус не победа и не проигрыш - играем
        system('cls') || system('clear')

        print_status
        ask_next_letter

      end

      print_status

    else
      puts "Press enter..."
    end
  end

  def files_initialize
    words_path = File.dirname(__FILE__ ) + "/data/words.txt"
    if File.exist?(words_path) #Если файл существует - продолжаем, нету - стопается прога и выводится текстовое оповещение
      words = File.new(words_path)
      @word = words.readlines.sample.chomp.split("") #Загрузка строк текстового файла в массив
      words.close
    else
      abort "Word store not found."
    end

    visual_path = File.dirname(__FILE__ ) + "/data/visual.txt"
    if File.exist?(visual_path)
      visual = File.new(visual_path)
      @image_status = visual.readlines
      visual.close
    else
      @image_status << "\n [image not found...] \n"
    end
  end

  def check_result(bukva)
    if @status == 2 || @status == 1 #Если статус игры победа или заканчиваются попытки - метод ничего не возвращает
      return
    end

    if @correct_letters.include?(bukva) || @uncorrect_letters.include?(bukva) #Если буквы уже есть в правильновведенных или неправильновведенных - ничего не возвращается
      return
    end

    if word.include?(bukva)
      @correct_letters << bukva
        if @correct_letters.uniq.sort == word.uniq.sort
          @status = 1
        end
    elsif bukva.split("") == word #Предусмотрена возможность сразу ввести слово
      @status = 1
    elsif bukva == "hint" && @correct_letters.uniq.sort == word.uniq.sort #Чтобы небыло несостыковок, подсказка может завершить игру
      @status = 1
    elsif bukva == "hint"
      return
    else
      @uncorrect_letters << bukva
      @error_counter += 1

      if @error_counter >= 5
        @status = 2
      end
    end
  end

  def ask_next_letter
    puts "\nEnter a letter..."

    letter = String.new

    while letter.empty?

      letter = gets.chomp.downcase

      if letter == "hint" && @counter < 3 #Даю возможность вызвать две подсказки, круто!
        hint = @word.uniq.sort - @correct_letters.uniq.sort
        @correct_letters << hint.sample
        @counter += 1
        @hints += 1
      end
    end

    check_result(letter)
  end

  def print_status
    system('cls') || system('clear')

    puts "Word: #{hide_word_print(@word, @correct_letters)}"
    puts "Errors (#{@error_counter}): #{@uncorrect_letters.join(", ")}"
    puts "You have #{(5 - @error_counter)} attempts"
    puts "Used attempts: #{@image_status[@error_counter]}"

    if @status == 1
      system('cls') || system('clear')

      puts "Success! You completed the game."
      puts "Hidden word: #{@word.join}"
      puts "Wrong answers: #{@error_counter}"
      puts "Used #{@hints} hints"
    elsif @status == 2
      system('cls') || system('clear')

      puts "The game is over!"
      puts "Hidden word: #{@word.join}"
      puts "Wrong answers: #{@error_counter}"
    end
  end

  def hide_word_print(word, correct_letters)
    result = String.new

    for item in word #здесь выводится так, неотгаданные буквы будут обозначаться нижним подчеркиванием, а то что было отгадано - просто буква
      if correct_letters.include?(item)
        result += item + " "
      else
        result += "_ "
      end
    end
    return result
  end
end