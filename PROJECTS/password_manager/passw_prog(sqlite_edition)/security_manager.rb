require "date" #проверки на актуальность пароля
require "sqlite3" #работа с xml документом
require "json" #для бэкапа
require "zip" #складирование бэкапов в архив

class Security_manager < Password_generator
  $encoding = String.new #сюда подгружается строка для возможности шифровки/дешифровки
  def initialize
    super
    @sqlite_base = ("data/sqlite_base.db") #можно было и не добавлять, указывать строку как путь, но сделал через переменную
    @uses_characters = (lowercase + uppercase + numbers).join("") #для удобства шифровки/дешифровки
  end


  def counter_reset #метод сброса значений тумблеров месяца
    file = File.new(@sqlite_base)
    sqlite_query = SQLite3::Database.open(file) #открываю линию общения с sqlite

    tumbler_hash = sqlite_query.execute("SELECT tumblers FROM critical_repository") #беру в данный момент строку из базы
    tumbler_hash = eval(tumbler_hash[0][0]) #превращаю в хэш тумблеров (до этого только вид хэша был)

    tumbler_hash.each_key do |key| #обнуляю все значения
      tumbler_hash[key] = 0
    end

    sqlite_query.execute("UPDATE critical_repository SET tumblers = \"#{tumbler_hash.to_s}\" WHERE rowid = 1") #и возвращаю ячейку информации обратно, уже опустошенную

    sqlite_query.close
    file.close
  end

  def annual_reset? #тут смотрится по году, если год входа больше первого года входа - его надо сбросить.

    file = File.new(@sqlite_base)
    sqlite_query = SQLite3::Database.open(file)

    trace_cell = sqlite_query.execute("SELECT trace_cell FROM critical_repository")[0][0]

    trace_cell = trace_cell.gsub("`", "\"")

    trace_cell = eval(trace_cell) #time означает время первого входа в программу

    if trace_cell[:status] == false
      sqlite_query.execute("UPDATE critical_repository SET trace_cell = \"{status: true, time: `#{Time.new.strftime("%d.%m.%Y")}`}\" WHERE rowid = 1") #отмечается запись состояния и вносится время записи состояния
    elsif trace_cell[:status] == true

      time_cell = Time.parse(trace_cell[:time])
      time_now = Time.now

      if time_now.year > time_cell.year
        counter_reset
        sqlite_query.execute("UPDATE critical_repository SET trace_cell = \"{status: false, time: nil}\" WHERE rowid = 1")
      end
    end

    sqlite_query.close
    file.close
  end

  def encryption_tool_update #запускается вместе с программой, этот метод смотрит, нужна ли перегенерация метода шифрования и выполняет обновление в случае надобности
    system("cls") || system("clear")

    unless File.exist?(@sqlite_base) #если база не создана - она создается с далее приведенной структурой

      unless Dir.exist?("data") #если папки нету - создается
        Dir.mkdir("data")
      end

      file = File.new(@sqlite_base, "w")

      sqlite_query = SQLite3::Database.open(file)

      sqlite_query.execute("CREATE TABLE passwords_storage (login datatype TEXT, password datatype TEXT, comment datatype TEXT, words datatype TEXT, date_creation datatype TEXT)")
      sqlite_query.execute("CREATE TABLE critical_repository (encoding datatype TEXT, tumblers datatype TEXT, trace_cell datatype TEXT)")
      sqlite_query.execute("INSERT INTO critical_repository (tumblers, trace_cell) VALUES (\"{1=>0, 2=>0, 3=>0, 4=>0, 5=>0, 6=>0, 7=>0, 8=>0, 9=>0, 10=>0, 11=>0, 12=>0}\", \"{status: false, time: nil}\")")

      sqlite_query.close
      file.close
    end

    file = File.new(@sqlite_base)
    sqlite_query = SQLite3::Database.open(file)

    tumbler_hash = sqlite_query.execute("SELECT tumblers FROM critical_repository")
    tumbler_hash = eval(tumbler_hash[0][0]) #делаю из строки хэш тумблеров

    annual_reset? #проверка на ежегодный сброс

    $encoding = sqlite_query.execute("SELECT encoding FROM critical_repository")[0][0] #наполняю строку имеющимся методом шифрования

    month_now = (Time.new).month #узнаю настоящий месяц

    if tumbler_hash[month_now.to_i] == 0 #если тумблер неактивен - нужен сброс, перегенерация не проводилась
      tumbler_hash[month_now] = 1

      new_encoding = @uses_characters.split("").shuffle.join("") #меняю строку на массив, использую shuffle чтобы символы случайным образом перемешались и превращаю обратно в строку

      sqlite_query.execute("UPDATE critical_repository SET tumblers = \"#{tumbler_hash.to_s}\" WHERE rowid = 1") #записываю уже новые переменные обратно на места
      sqlite_query.execute("UPDATE critical_repository SET encoding = \"#{new_encoding}\" WHERE rowid = 1")

      new_encrypted_base = sqlite_query.execute("SELECT login, password, comment, words FROM passwords_storage") #смотрю нужные элементы, которые нуждаются в перешифровке

      if (new_encrypted_base.size) < 1 #если в базе нету элементов - выхожу
        $encoding = new_encoding #это случай, если база была не создана, а значит метода шифрования нету, присваиваю новый
        return
      end

      #тут сделаю backup в формате json, чтобы данные были в целостности (сохраню с существующим методом шифрования, чтобы в случае чего воспользоваться им и благополучно вернуть данные так как нужно проверить еще временем работу программы)

      backup_data = sqlite_query.execute("SELECT * FROM passwords_storage") #беру все данные из базы для их сохранения в json формате

      file_name = Time.new.strftime("%d_%m_%y-[%k~%M]") #название файла бэкапа будет в формате 01.01.23 [10~10]

      hash_backup_items = Hash.new #подготавливаю к записи загружая нужную информацию
      hash_backup_items.merge!({"encoding" => $encoding}) #средство шифрования для расшифровки!

      backup_data.each_with_index do |item, index| #в существующий хэш добавляю хэш с порядковым номером, который содержит массив данных (ячейка данных sqlite)
        element = {index => item}
        hash_backup_items.merge!(element)
      end

      file_backup = File.new("data/backup-#{file_name}.json", "w:UTF-8") #создаю файл бэкапа в режиме записи
      file_backup.puts(JSON.pretty_generate(hash_backup_items)) #записываю в красивом виде!
      file_backup.close

      unless File.exist?("data/backups.zip") #если не создан архив - он создается
        zip_file = Zip::File.new('data/backups.zip', Zip::File::CREATE)
        zip_file.close
      end

      Zip::File.open("data/backups.zip", create: false) do |zip| #открывается архив и в него копируется уже созданный файл бэкапа
        zip.add("backup-#{file_name}.json", "data/backup-#{file_name}.json")
      end

      File.delete("data/backup-#{file_name}.json") #удаляется файл, который уже не нужен

      #окончание бэкапа

      new_encrypted_base.each do |element| #если элементы есть - декодирую с помощью прошлого набора шифрования
        element[0] = element[0].tr($encoding, @uses_characters) #расшифровка логина
        element[1] = element[1].tr($encoding, @uses_characters) #пароля
        element[2] = element[2].tr($encoding, @uses_characters) #коммента
        if element[3] != nil
          element[3] = element[3].tr($encoding, @uses_characters) #слов, если есть
        end
      end

      def update_values(sqlite, login, password, comment, words, id) #перезапись происходит только той части, которая нуждается в перешифровке
        sqlite.execute("UPDATE passwords_storage SET login = \"#{login}\" WHERE rowid = \"#{id}\"")
        sqlite.execute("UPDATE passwords_storage SET password = \"#{password}\" WHERE rowid = \"#{id}\"")
        sqlite.execute("UPDATE passwords_storage SET comment = \"#{comment}\" WHERE rowid = \"#{id}\"")
        if words != nil #если слова вообще есть - они перезаписываются
          sqlite.execute("UPDATE passwords_storage SET words = \"#{words}\" WHERE rowid = \"#{id}\"")
        end
      end

      counter = 1 # нумерация строк в sqlite начинается с одного, эта переменная отвечает за порядковый номер элемента sqlite базы
      index = 0 #указывает на порядковый номер элемента хэша, который был взят из sqlite базы

      (new_encrypted_base.size).times do #сколько строчек было в базе - столько раз произойдет перезапись
        login = new_encrypted_base[index][0].tr(@uses_characters, new_encoding) #передаю в переменные расшифрованные старым способом данные и шифрую их с новым методом
        password = new_encrypted_base[index][1].tr(@uses_characters, new_encoding)
        comment = new_encrypted_base[index][2].tr(@uses_characters, new_encoding)
        if new_encrypted_base[index][3] == nil
          words = nil
        else
          words = new_encrypted_base[index][3].tr(@uses_characters, new_encoding)
        end

        update_values(sqlite_query, login, password, comment, words, counter)

        counter += 1
        index += 1
      end

      sqlite_query.close
      file.close

      $encoding = new_encoding #присвоение нового метода шифровки на замену устаревшего
    end

    sqlite_query.close
    file.close
  end

  def delete_cell #метод удаления наполнения sqlite базы
    file = File.new(@sqlite_base)
    sqlite_query = SQLite3::Database.open(file)

    database = sqlite_query.execute("SELECT * FROM passwords_storage")

    puts "Select the number of the cell to be deleted. Write `exit` to return to the main menu."
    user_input = gets.chomp

    while
      if user_input == "exit"
        return
      elsif user_input.to_i == 0 || user_input.to_i > (database.size) || user_input.to_i.negative? #число ожидаемое от пользователя не может превышать размера суммы элементов sqlite базы
        puts "Input correct answer..."
        user_input = gets.chomp
      end
    end

    login = database[user_input.to_i - 1][0]
    password = database[user_input.to_i - 1][1]
    date_creation = database[user_input.to_i - 1][4]

    begin
      sqlite_query.execute("DELETE FROM passwords_storage WHERE login = \"#{login}\" AND password = \"#{password}\" AND date_creation = \"#{date_creation}\"")
    rescue
      puts "An error occurred while deleting!".red
    else
      puts "\nSelected item number #{user_input.to_i} is removed!"
    end

    sqlite_query.close
    file.close

    sleep(1)

    print_sqlite_base #и снова печать
  end

  def password_change_reminder(value) #метод, указывающий на необходимость в смене пароля

    time_now = Time.new #создаю переменную с временем, далее буду брать информацию о нём по части

    time_cell = Date.parse(value) #время созданного пароля

    if time_now.year > time_cell.year #Первое, что нужно понять - год, если год создания ячейки с паролем меньше, чем сегодняшний - его нужно заменить, 3 месяца прошли точно
      puts "[replace, 3 months have passed]".colorize(31)
    elsif time_now.year < time_cell.year #Бредовый конечно вариант, но допустим он случился...
      puts "Cell from future!?".colorize(31)
    else
      if (time_now.month - time_cell.month) > 3 #Дальше если разница настоящего месяца и месяца создания пароля больше трёх - пароль нужно менять
        puts "[replace, 3 months have passed]".colorize(31)
      end

      if (time_now.month - time_cell.month) == 3 #Если разница = 3, продолжаю проверку
        if time_now.day == time_cell.day #Дни совпали - 3 месяца прошло
          puts "[replace, 3 months have passed]".colorize(31)
        else
          difference = time_now.day - time_cell.day
          if difference.negative? #Считаю разницу дней, если она в отрицательном диапазоне, 3 месяца прошли. Если в положительном - показываю оставшиеся дни до завершения периода смены пароля
            puts "[replace, 3 months have passed]".colorize(31)
          else
            puts "[need to replace after #{difference} days]".colorize(31)
          end
        end
      end
    end
  end

  def print_sqlite_base #метод печати sqlite-базы
    system("cls") || system("clear")

    file = File.new(@sqlite_base)
    sqlite_query = SQLite3::Database.open(file)

    database = sqlite_query.execute("SELECT * FROM passwords_storage")

    if database.size < 1 #если база не содержит ячеек с паролем-логином - сворачиваю удочки, ловить нечего
      puts "database is empty..."
      sleep(1)
      return
    end

    counter = 0
    index = 1

    (database.size).times do
      puts str = "--------------[#{index}]--------------"
      begin
      password_change_reminder(database[counter][4])
      puts "comment: #{database[counter][2].tr($encoding, @uses_characters)}"
      puts "\nlogin: #{database[counter][0].tr($encoding, @uses_characters)}"
      if (database[counter][3]) != nil
        puts "word list: #{database[counter][3].tr($encoding, @uses_characters)}"
      end
      puts "password: #{database[counter][1].tr($encoding, @uses_characters)}\n\n\n"
      rescue
        puts "[ structure CELL is corrupted ]\n\n\n".colorize(33)
        puts
      end

      index += 1
      counter += 1
    end

    sqlite_query.close
    file.close

    delete_cell #предлагаю удалить ячейку при просмотре базы
  end

  def encryption(login, generation_result, comment, word_storage) #метод шифрует вводимые данные и сохраняет их в sqlite базу
    #"Шифровка #{password.tr(uses_characters, $encoding)}"
    #"Дешифровка #{password.tr($encoding, uses_characters)}"

    password = generation_result.join("")
    encode_login = login.tr(@uses_characters, $encoding)
    encode_password = password.tr(@uses_characters, $encoding)
    encode_comment = comment.tr(@uses_characters, $encoding)

    file = File.new(@sqlite_base)
    sqlite_query = SQLite3::Database.open(file)

    begin #проверка на ошибку, в случае, если база по какой-то причине не создалась ранее
      if word_storage.size != 0 #запись, отведённая для мнемонического пароля
        word_storage = word_storage.join(", ")
        encode_words = word_storage.tr(@uses_characters, $encoding)
        sqlite_query.execute("INSERT INTO passwords_storage (login, password, comment, words, date_creation) VALUES (\"#{encode_login}\", \"#{encode_password}\", \"#{encode_comment}\", \"#{encode_words}\", \"#{Time.new.strftime("%d.%m.%Y")}\")")
      else #запись, отведённая для случайного пароля
        sqlite_query.execute("INSERT INTO passwords_storage (login, password, comment, date_creation) VALUES (\"#{encode_login}\", \"#{encode_password}\", \"#{encode_comment}\", \"#{Time.new.strftime("%d.%m.%Y")}\")")
      end
    rescue
      puts "Error, information not saved!".colorize(31)
    else
      puts "\nSaved!" #отчет о проделанном
    end

    sqlite_query.close
    file.close

    sleep(0.5)

  end
end

