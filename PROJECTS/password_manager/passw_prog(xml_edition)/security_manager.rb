class Security_manager < Password_generator
  $encoding = String.new #сюда подгружается строка для возможности шифровки/дешифровки
  def initialize
    super
    @xml_base = ("data/base.xml") #можно было и не добавлять, указывать строку как путь, но сделал через переменную
    @uses_characters = (lowercase + uppercase + numbers).join("") #для удобства шифровки/дешифровки
    @variations = ["[-        ]", "[- -      ]", "[- - -    ]", "[- - - -  ]", "[- - - - -]"]
  end

  def counter_reset #метод сброса значений тумблеров месяца
    file = File.new(@xml_base)
    xml_doc = REXML::Document.new(file)

    tumbler_hash = ""

    xml_doc.elements.each("core/critical_cell") do |element| #беру пока что строку
      tumbler_hash = element.text
    end

    puts tumbler_hash = eval(tumbler_hash) #превращаю строку в хэш

    tumbler_hash.each do |key, value| #обнуляю все ключи
      tumbler_hash[key] = 0
    end

    new_tumbler_hash = tumbler_hash.map{|k,v| "#{k}=>#{v}"}.join(', ') #превращаю обратно в строку хэш
    new_tumbler_hash.insert(0, "{")
    new_tumbler_hash.insert((new_tumbler_hash.size), "}")

    xml_doc.root.elements['critical_cell'].text = new_tumbler_hash #присваиваю строку

    File.open(@xml_base, 'w:UTF-8') do |file| #записываю изменения
      xml_doc.write(file, 2)
    end
  end

  def encryption_tool_update
    system("cls") || system("clear")

    unless File.exist?(@xml_base) #если файла нету - ошибка и выход
      puts "Critical error, database not found"
      sleep(4)
      exit
    end

    file = File.new(@xml_base)
    xml_doc = REXML::Document.new(file)

    tumbler_hash = ""

    xml_doc.elements.each("core/critical_cell") do |element| #беру строку тумблеров и строку для шифровки/дешифровки
      tumbler_hash = element.text
      $encoding = element.attributes["encoding"]
    end

    tumbler_hash = eval(tumbler_hash) #делаю из строки в хэш тумблеров

    month_now = (Time.new).month

    if tumbler_hash[month_now.to_i] == 0 #если тумблер неактивен - нужен сброс
      tumbler_hash[month_now] = 1

      new_encoding = @uses_characters.split("").shuffle.join("") #меняю строку на массив, использую shuffle чтобы символы случайным образом перемешались и превращаю обратно в строку
      new_tumbler_hash = tumbler_hash.map{|k,v| "#{k}=>#{v}"}.join(', ')
      new_tumbler_hash.insert(0, "{")
      new_tumbler_hash.insert((new_tumbler_hash.size), "}")

      xml_doc.root.elements['critical_cell'].add_attribute('encoding', new_encoding)
      xml_doc.root.elements['critical_cell'].text = new_tumbler_hash

      File.open(@xml_base, 'w:UTF-8') do |file|
        xml_doc.write(file, 2)
      end

      if xml_doc.root.elements.size >= 2 #если есть в базе один элемент или более - считываю данные для их перезаписи с новым методом шифровки
        new_encrypted_base = Hash.new
        xml_doc.elements.each_with_index("core/cell") do |element, index|
          new_encrypted_base[index] = element.attributes["comment"], element.attributes["password_words"], element.text.strip, element.attributes["date"]
        end
      else
        return
      end

      new_encrypted_base.each do |key, value|
        value.reject!(&:nil?) #убираю у массива значение nil

        if value.size == 3 #дешифровка информации
          value[0] = value[0].tr($encoding, @uses_characters)
          value[1] = value[1].tr($encoding, @uses_characters)
        elsif value.size == 4
          value[0] = value[0].tr($encoding, @uses_characters)
          value[1] = value[1].tr($encoding, @uses_characters)
          value[2] = value[2].tr($encoding, @uses_characters)
        end
      end

      key = 0

      xml_doc.elements.each("core/cell") do |element| #перезапись ячеек с использованием нового метода шифровки
        if element.attributes.size == 2
          element.add_attribute("comment", (new_encrypted_base[key][0].tr(@uses_characters, new_encoding)))
          element.add_attribute("date", new_encrypted_base[key][2])
          element.text = new_encrypted_base[key][1].tr(@uses_characters, new_encoding)
          key += 1
        elsif element.attributes.size == 3
            element.add_attribute("comment", (new_encrypted_base[key][0].tr(@uses_characters, new_encoding)))
            element.add_attribute("password_words", (new_encrypted_base[key][1].tr(@uses_characters, new_encoding)))
            element.add_attribute("date", new_encrypted_base[key][3])
            element.text = new_encrypted_base[key][2].tr(@uses_characters, new_encoding)
            key += 1
        end
      end

      File.open(@xml_base, 'w:UTF-8') do |file|
        xml_doc.write(file, 2)
      end

      $encoding = new_encoding #присвоение нового метода шифровки на замену устаревшего
    end
  end

  def delete_cell #метод удаления ячейки xml базы
    file = File.new(@xml_base)
    xml_doc = REXML::Document.new(file)

    puts "Select the number of the cell to be deleted. Write `exit` to return to the main menu."
    user_input = gets.chomp.to_s #to_i преобразовывает ответ пользователя в число, если будет текст - возвратится 0
    value = 0

    while
      if user_input == "exit"
        value += 1
        break
      elsif user_input.to_i == 0 || user_input.to_i > ((xml_doc.root.elements.size).to_i - 1) #число ожидаемое от пользователя не может превышать размера суммы корневых элементов xml документа
        puts "Input correct answer..."
        user_input = gets.chomp.to_s
      end
    end

      if value == 0
          xml_doc.elements.each("core/cell") do |item| #проверяю каждую ячейку на наличие комментария, который есть в выбранном для удаления, совпадение - удаляю. Для более точного отбора добавляю в проверку дату
            if item.attributes["comment"] == ($hash[user_input.to_i])[0] && item.attributes["date"] == ($hash[user_input.to_i])[3]
              puts "\nSelected item number #{user_input.to_i} is removed!"
              xml_doc.root.elements.delete(item)
            end
        end

        sleep(2)

        File.open(@xml_base, 'w') do |file| #осталось записать выше сделанные изменения, записываю
          xml_doc.write(file)
        end

        print_xml_base #и снова показываю xml базу

      end
  end

  def password_change_reminder(value) #метод, указывающий на необходимость в смене пароля

    time_now = Time.new #создаю переменную с временем, далее буду брать информацию о нём по части

    time_cell = Date.parse(value[3]) #время созданного пароля

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

  def print_xml_base #метод просмотра xml-базы
    system("cls") || system("clear")

    file = File.new(@xml_base)
    xml_doc = REXML::Document.new(file)

    unless File.exist?(@xml_base) #Если xml документа нету - нечего обрабатывать
      puts "database not created!"
      sleep(2)
      exit
    end

    if xml_doc.root.elements.size <= 1 #если база не содержит ячеек с паролем-логином - сворачиваю удочки, ловить нечего
      puts "database is empty..."
      sleep(2)
      return
    end

    $hash = Hash.new

    xml_doc.elements.each_with_index("core/cell") do |element, index| #Наполняю хэш информацией с xml документа в структурированном виде
      $hash[index + 1] = element.attributes["comment"], element.attributes["password_words"], element.text.strip, element.attributes["date"]
    end

    $hash.each do |key, value| #вывожу в консоль хэш, дублирующий базу xml в надлежащем виде
      begin #если в выводе информации ошибка - целостность ячеек информации была нарушена
        puts str = "--------------[#{key}]--------------" #красивая шторка с порядковым номером ячейки
        password_change_reminder(value) #проверка на 3-х месячную длительность существования пароля
        puts "login: #{value[0].tr($encoding, @uses_characters)}" #печать с расшифровкой зашифрованных значений xml документа
        if value[1] != nil
          puts "word list: #{value[1].tr($encoding, @uses_characters)}"
        end
          puts "password: #{value[2].tr($encoding, @uses_characters)}\n\n\n"
      rescue
        puts "[ structure CELL is corrupted ]\n\n\n".colorize(33)
        puts
      end
    end

    delete_cell #предлагаю удалить ячейку при просмотре базы

  end

  def encryption(array, comment, word_storage) #метод шифрует вводимые данные и сохраняет их в xml документ

    #"Шифровка #{password.tr(uses_characters, $encoding)}"
    #"Дешифровка #{password.tr($encoding, uses_characters)}"

    password = array.join("")
    encode_result = password.tr(@uses_characters, $encoding)

    unless File.exist?(@xml_base) #если xml документа нету - происходит создание
      file = File.new(@xml_base, "w")
      file.puts("<?xml version='1.0' encoding='UTF-8'?>")
      file.puts("<core></core>")
      file.close
    end

    file = File.new(@xml_base)
    xml_doc = REXML::Document.new(file)

    if word_storage.size != 0 #запись, отведённая для мнемонического пароля
      cell = xml_doc.root.add_element("cell", {"comment" => comment.tr(@uses_characters, $encoding), "password_words" => word_storage.join(" ").tr(@uses_characters, $encoding), "date" => Time.new.strftime("%d.%m.%Y")})
      cell.add_text(encode_result) #добавляю в корневой раздел ячейку данных с нужной информацией о ранее выполненной генерации
    else #запись, отведённая для случайного пароля
      cell = xml_doc.root.add_element("cell", {"comment" => comment.tr(@uses_characters, $encoding), "date" => Time.new.strftime("%d.%m.%Y")})
      cell.add_text(encode_result)
    end

    File.open(@xml_base, 'w:UTF-8') do |file| #сохранение изменений!
      xml_doc.write(file, 2)
    end

    puts "\nSaved!" #отчет о проделанном
    sleep(2)
  end
end

