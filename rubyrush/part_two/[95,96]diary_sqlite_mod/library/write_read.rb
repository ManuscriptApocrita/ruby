require "sqlite3" #библиотека начинает работать в самом классе, а не основной программе!

class WriteRead
  def initialize
    @created_at = Time.now
    @text = []
    @sqlite_path = File.dirname(__FILE__ ).chomp!("library") + "/storage/diary_DB_sqlite.db" #т.к путь прописан в классе, нужно удалять папку, в которой он находится, чтобы попасть к главной директории
  end

  def self.read_base
    sqlite_path = File.dirname(__FILE__ ).chomp!("library") + "/storage/diary_DB_sqlite.db"

    begin #если происходит ошибка в этом блоке кода - значит базы нету. Информирую
    db_sqlite = SQLite3::Database.open(sqlite_path)

    db_sqlite.results_as_hash = true #ответы базы возвращаются в массиве, наполненным хэшами!

    base_data = db_sqlite.execute("SELECT * FROM diary") #загружаю массив хэшей в переменную
    rescue
      abort "Base not found! (SQLite3::SQLException)"
    end

    if base_data.size == 0
      puts "base is empty!"
      exit
    end

    base_data.each_with_index do |item, index| #вывожу в надлежащем виде то, что лежит в хэше (а ранее в sqlite)
      print "#{index + 1}. "

      item.each do |key, value|
        print "#{key} #{value} "
      end
    end

    puts "\nWhat`s you want delete?"

    user_input = gets.to_i

    if user_input != 0 && user_input <= base_data.size #удаление из таблицы происходит по соответствию выбранного пользователем (из выбранной ячейки данных берется значение даты создания) и тем, что находится в базе
      result = base_data[user_input - 1]

      db_sqlite.execute("DELETE FROM diary WHERE created_at = \"#{result[3]}\"")
    else
      puts "You choise incorrect answer!"
    end
  end

  def initialize_base
    @sqlite_path = File.dirname(__FILE__ ).chomp!("library") + "/storage/diary_DB_sqlite.db"

    unless File.exist?(@sqlite_path)
      file = File.new(@sqlite_path, "w")

      db_sqlite = SQLite3::Database.open(@sqlite_path)
      db_sqlite.execute("CREATE TABLE diary (type datatype TEXT, content datatype TEXT, deadline datatype TEXT, created_at datatype TEXT)")

      file.close
    end
  end

  def save #сохранение! элементы массива загружаются в соответствующие переменные sqlite
    initialize_base #если базы нету - она создается с верным набором табличных элементов для дальнейшей работы

    db_sqlite = SQLite3::Database.open(@sqlite_path)

    if to_strings[0] == "Note"
      db_sqlite.execute("INSERT INTO diary (type, content, deadline, created_at) VALUES (\"#{to_strings[0]}\", \"#{to_strings[1]}\", NULL, \"#{to_strings[2]}\")")
    elsif to_strings[0] == "Task"
      db_sqlite.execute("INSERT INTO diary (type, content, deadline, created_at) VALUES (\"#{to_strings[0]}\", \"#{to_strings[1]}\", \"#{to_strings[2]}\", \"#{to_strings[3]}\")")
    end
  end

  def read_from_console
    #нужно классу-ребёнку
  end

  def to_strings
    #нужно классу-ребёнку
  end
end
