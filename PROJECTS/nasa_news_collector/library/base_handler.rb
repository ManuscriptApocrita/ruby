require "mechanize"
require "json"
require "yaml"
require "progress_bar"

class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
end

class Base_handler
  def initialize
    @result_hash = {}
    @all_months = Date::MONTHNAMES.compact #возвращает массив на английском с первым элементом "nil"
    @entries_size = 0 #сюда дополняется количество созданных файлов для информативности
    @settings = JSON.parse(File.read(File.dirname(__FILE__ ) + "/settings.json")) #файл настроек с прокси и переключателем
  end

  def entries_size?
    return @entries_size
  end

  def start_program
    system("cls") || system("clear")
    puts "[NASA news collector] " + "version 1.0".colorize(34)
    puts "\nThis program talks to the NASA server and creates a local copy of all press releases. After the first initialization of the program, it is possible to supplement the database by analyzing what is missing."

    if not @settings["last_update"].empty?
      time_now = Time.new #создаю переменную с временем, далее буду брать информацию о нём по части
      last_update_date = Time.parse(@settings["last_update"]) #время созданного пароля
      logic_answer = ""

      if time_now.year > last_update_date.year #первое, что нужно понять - год, если год последнего обновления меньше, чем сегодняшний - его нужно заменить, месяц прошел точно
        logic_answer << "you may do update!".colorize(32)
      else
        if (time_now.month - last_update_date.month) > 1 #дальше если разница настоящего месяца и последнего обновления больше одного - базу можно обновлять
          logic_answer << "you may do update!".colorize(32)
        end

        if (time_now.month - last_update_date.month) == 1 #если разница в один месяц 1, продолжаю проверку
          if time_now.day == last_update_date.day #дни совпали - месяц прошел
            logic_answer << "you may do update!".colorize(32)
          else
            difference = time_now.day - last_update_date.day
            if difference.negative? #считаю разницу дней, если она в отрицательном диапазоне, месяц прошел. Если в положительном - показываю оставшиеся дни до завершения
              logic_answer << "you may do update!".colorize(32)
            else
              logic_answer << ("#{difference.to_s} days...").colorize(33)
            end
          end
        elsif (time_now.month - last_update_date.month) == 0 #если разницы нету и один и тот же месяц
          if time_now.day == last_update_date.day
            days_to_update = 30
          else
            difference = (time_now.day - last_update_date.day)
            if difference.negative?
              difference = difference.abs
            end
            days_to_update = 30 - difference
          end

          logic_answer << ("#{days_to_update.to_s} days...").colorize(33)
        end
      end
    end

    if @settings["last_update"].empty?
      puts "\nYou want to update database? No updates before..."
    else
      puts "Warning: it is better to update the database no more than once a month.".colorize(31)
      puts "\nYou want to update database? Last update was: #{@settings["last_update"]}, until the next recommended update: #{logic_answer}"
    end
    puts "\nyes - 1, exit - 0"

    user_input = nil
    until user_input == 1 || user_input == 0
      user_input = gets.chomp.to_i
    end

    if user_input == 0
      exit
    else
      @settings["last_update"] = (Time.new).strftime("%Y-%m-%d")
      file = File.open(File.dirname(__FILE__ ) + "/settings.json", "w")
      file.write(JSON.pretty_generate(@settings))
      file.close
    end

    system("cls") || system("clear")
  end

  def http_request_nasa_server #здесь обращаюсь к серверу и делаю первичные действия с данными
    agent = Mechanize.new
    # agent.set_proxy(@settings["proxy"][0], @settings["proxy"][1]) #ранее в значении элемента хэша заполнил массив нужным образцом
    tumbler = 0 #для фиксации наличия действия

    begin
      if @settings["global_update"] == 0 #если полное обновление базы не производилось (а узнаю я это из файла настроек) - оно выполняется
        http_request = agent.get("https://www.nasa.gov/api/2/ubernode/_search?size=1&q=(ubernode-type:press_release)") #первым запросом узнаю количество пресс-релизов
        total_releases = JSON.parse(http_request.body)["hits"]["total"] #беру значение того, сколько всего существует в базе записей
        http_request = agent.get("https://www.nasa.gov/api/2/ubernode/_search?size=#{total_releases}&q=(ubernode-type:press_release)&_source_include=promo-date-time,body,title,release-id,uri") #читаю все записи в сокращенном виде плюс без сортировки, и так к серверу обращаюсь с огромным запросом, лишний раз грузить не нужно :-)
        tumbler += 1 #если присвоилось значение - глобальное обновление прошло успешно
      else #в ином случае использую другой подход
        last_change_folder = ""

        2.times do |iteration| #2 раза потому что нужно обработать одним шаблоном две папки
          dirname_array = []
          if iteration == 1 #нахожу вторую итерацию и меняю часть кода
            actual_path = last_change_folder
          else
            actual_path = File.dirname(__FILE__ ).gsub(/\/library/, "") + "/press_releases_nasa" #сам файл с классом находится в папке "библиотека", решил, что будет складироваться информация о релизах возле либрари
          end

          Dir.foreach(actual_path) do |dirname| #сейчас нахожусь в корневой директории релизов, где располагаются папки годов, беру их названия
            next if dirname == '.' || dirname == '..' #избегаю ненужых элементов
            dirname_array << dirname
          end

          elements_to_delete = []

          dirname_array.each do |folder| #удаляю пустые папки по индексу!!!
            if Dir.empty?(actual_path + "/#{folder}")
              elements_to_delete << folder
            end
          end

          if elements_to_delete.size != 0
            elements_to_delete.each do |element|
              dirname_array.delete(element)
            end
          end

          last_change_folder = actual_path + "/#{dirname_array.max}" #выбираю из папок ту, в которой находится самый свежий релиз, второй итерацией я получаю папку месяца в которой находится самый свежий релиз
        end

        all_releases = []
        Dir.foreach(last_change_folder) do |release_name| #теперь я могу просмотреть файлы в папке, беру все названия, и делаю их типа дата
          next if release_name == '.' || release_name == '..'
          all_releases << Date.parse(release_name)
        end

        fresh_release = all_releases.max.to_s #из массива в точности узнаю свежую дату, и беру её строкой

        selector = 0
        counter = 1

        while selector == 0 #время запросов!!
          puts "Request ##{counter} to NASA database, please wait, local base are updating..."
          http_request = agent.get("https://www.nasa.gov/api/2/ubernode/_search?size=#{counter * 24}&sort=promo-date-time:desc&q=(ubernode-type:press_release)&_source_include=promo-date-time,body,title,release-id,uri") #теперь уже серверная сортировка нужна, получаю десять последних релизов
          press_releases = JSON.parse(http_request.body)

          press_releases["hits"]["hits"].each do |release|
            date_of_release = Date.parse(release["_source"]["promo-date-time"]).to_s

            if date_of_release.include?(fresh_release) #пробегаюсь по всем датам и в результате понимаю, есть ли соответствие с локальной последней датой, нету - нужно глянуть дальше, увеличиваю количество запросов
              selector = 1
            end
          end
          counter += 1

          sleep(rand(1..3)) #чтобы лишний раз не делать нагрузку на сервер непрерывными запрсоами
        end
      end
    rescue
      abort "Ethernet error..." #в случае ошибки прокси лишних действий не совершится!
    end

    if tumbler == 1 #если произошло глобальное обновление - изменяю состояние тумблера и записываю в файл
      @settings["global_update"] = 1
      file = File.open(File.dirname(__FILE__ ) + "/settings.json", "w")
      file.write(JSON.pretty_generate(@settings))
      file.close
    end

    json_form_releases = JSON.parse(http_request.body) #запрос выше был совершен, парсинг данных!

    desired_type = []
    json_form_releases["hits"]["hits"].each do |release| #пока отбор по части базы, которая более-менее корректно загружается
      link = release["_source"]["uri"]

      if link.match(/^\/press-release\//) #беру все типы ссылок типа "пресс-релиз"
        desired_type << release
      end
    end

    return desired_type
  end

  def processing_press_release(release, iteration)
    @result_hash[iteration] = {title: 0, date: 0, release_no: 0, article: 0, uri: 0}

    iteration = @result_hash[iteration]
    iteration[:title] = release["_source"]["title"]
    iteration[:date] = Date.parse(release["_source"]["promo-date-time"]).strftime("%Y-%m-%d")
    if release["_source"]["release-id"] == nil
      iteration[:release_no] = "nothing"
    else
      iteration[:release_no] = release["_source"]["release-id"]
    end
    iteration[:uri] = release["_source"]["uri"]

    paragraphs = Nokogiri::HTML(release["_source"]["body"]).search("p, li") #текст находится в этих двух тэгах, их и беру

    article = ""

    paragraphs.each do |paragraph| #прохожусь по всему тексту, а именно по каждому тегу в отдельности
      text = (paragraph.text)

      if text == "-end-" || text == "- end -" || text == "Back to NASA Newsroom | Back to NASA Homepage" ||
        text == "text-only version of this release" || (/NASA press releases and other information are available automatically/).match?(text) ||
        text.empty? || text.match(/-nasa-/i) || text == "Printer Friendly Version"
        next #избавляюсь от ненужных строк просто пропуская их!
      end

      text.delete!("\r\n\t") #дополнительная обработка текста, лишнее убираю
      text.gsub!("", " ")
      text.gsub!("”", "\"")
      text.gsub!("“", "\"")
      text.gsub!("'", "`")
      text.gsub!("’", "`")
      text.gsub!(" ", " ") #NNBSP
      text.gsub!("\u00A0", "") #NBSP
      text.gsub!("\u200B", "") #ZWSP

      if paragraph.name == "li" #если попадается элемент списка, а они идут друг за другом - отступ не нужен
        article << "*" + text + " "
      else
        article << text + "\n"
      end
    end

    article.slice!(-1) if article.end_with?("\n") #убираю последний пробел, если он есть
    iteration[:article] = article
  end

  def accumulation_and_branching(array)
    actual_path = File.dirname(__FILE__ ).gsub(/\/library/, "")

    if not Dir.exist?(actual_path + "/press_releases_nasa")
      Dir.mkdir(actual_path + "/press_releases_nasa") #создаю основную папку
    end

    all_releases_years = {} #просматриваю года всех релизов и собираю их в хэше с значением - массив
    array.each do |release|
      year_of_release = Date.parse(release["_source"]["promo-date-time"]).strftime("%Y")
      if !all_releases_years.keys.include?(year_of_release)
        all_releases_years[year_of_release] = []
      end
    end

    all_releases_years.each_key do |key|
      @result_hash.each do |release| #сортирую информацию по годам
        release_date = release[1][:date]
        if Date.parse(release_date).strftime("%Y") == key
          all_releases_years[key] << release
        end
      end
    end

    all_releases_years.each do |year, array_of_releases|
      year_folder = actual_path + "/press_releases_nasa/#{year}"

      if !Dir.exist?(year_folder)
        Dir.mkdir(year_folder)
      end

      puts "Examine yaml files... processing #{year} year - #{array_of_releases.size} elements" #красивый информационный элемент!
      bar = ProgressBar.new(array_of_releases.size, :bar, :percentage, :eta, :rate) #выбираю нужные элементы бара

      @all_months.each_with_index do |month, index|
        month_folder_path = year_folder + "/[#{index + 1}]##{month}"

        if !Dir.exist?(month_folder_path)
          Dir.mkdir(month_folder_path)
        end

        array_of_releases.each do |release|

          date_of_release = Date.parse(release[1][:date].to_s)

          if date_of_release.strftime("%B") == month #ранее я собрал в куче все релизы по году, теперь нахожу соответствие с итерируемым месяцом и в зависимости от этого помещаю в нужную папку
            encrypt_title = String.new
            title = (release[1][:title]).split #из названия релиза делаю уникальный идентификатор релиза!!
            title.each do |item|
              item.gsub!(/\W+/, "") #все то, что не буква и не цифра - исчезает из строки, это нужно, а то сыпятся ошибки, символы недопустимые
            end
            title.compact! if title.include?(nil) #аккуратно чищу nil элементы
            title.reject!(&:empty?) #убираю пустые элементы

            if title.size <= 4 #если название содержит меньше пяти слов - использую все для шифровки
              title.each do |item|
                encrypt_title += item[0].downcase
              end
            else
              (title.last(4)).each do |item| #если больше четырех - последние четыре слова
                encrypt_title += item[0].downcase #тут не принципиально, пусть в нижнем регистре все будет, единообразие!
              end
            end

            release_path = "#{month_folder_path}/#{date_of_release}[#{encrypt_title}].yaml" #по такому пути не заблудишься...

            if !File.exist?(release_path)
              file = File.open(release_path, "w")
              yaml = (release[1].to_yaml)
              file.write(yaml)
              file.close
              @entries_size += 1 #если запись происходит - я знаю количество сделанных записей
            end

            bar.increment! #обновляю статусную строку, добавляю незначительные задержки, так интереснее :-)
            if rand(2) == 1
              sleep(0.005)
            else
              sleep(0.01)
            end

          end
        end
      end
    end
  end

end