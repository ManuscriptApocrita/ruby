require "mechanize"
require "json"
require "yaml"
require "progress_bar"
require_relative "modifications"

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
    puts "[NASA news collector] " + "version 2.0".colorize(35)
    puts "\nThis program talks to the NASA server and creates a local copy of all press releases. After the first initialization of the program, it is possible to supplement the database by analyzing what is missing."

    if not @settings["last_update"].empty?
      logic_answer = remaining_time_analysis(Time.parse(@settings["last_update"]))
    end

    if @settings["last_update"].empty?
      puts "\nYou want to update database? No updates before..."
    else
      puts "\nAdvice: it is better to update the database no more than once a week.".underline
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
        puts "First request to NASA server, please wait, local base are updating..."
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
          puts "Request ##{counter} to NASA server, please wait, local base are updating..."
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

    all_pass_releases = []
    unrecognized_types = []
    known_types = %w(press-release centers home press larc langley wallops
    mission_pages exploration Wallops ames marshall directorates feature archive
    news spacetech topics beta release stem v center enters 8k-science)

    json_form_releases["hits"]["hits"].each do |release| #отбор производится по всем разновидностям пресс релизов, которые известны на момент середины 2023 года
      link = release["_source"]["uri"]
      link = link.split(/\//).reject { |item| item.empty? }

      if known_types.include?(link[0])
        all_pass_releases << release
      else
        unrecognized_types << "#{link[0]}(#{release["_source"]["title"]})"
      end
    end

    return [unrecognized_types, all_pass_releases]
  end

  def exception_logging(unrecognized_types)
    puts "\nFound unknown types of releases: #{unrecognized_types.size}, the database was not filled with them, contact the vendor of the program to analyze the log file."

    log_file = JSON.parse(File.read(File.dirname(__FILE__ ) + "/log.json"))
    unrecognized_types.each do |element|
      log_file["unknown_types"] << element if not log_file["unknown_types"].include?(element)
    end

    file = File.open(File.dirname(__FILE__ ) + "/log.json", "w")
    file.write(JSON.pretty_generate(log_file))
    file.close
  end

  def processing_press_release(release, iteration)
    @result_hash[iteration] = {title: 0, date: 0, release_no: 0, article: 0}
    iteration = @result_hash[iteration]
    title_unprocessed = release["_source"]["title"]
    date_unprocessed = Date.parse(release["_source"]["promo-date-time"]).strftime("%Y-%m-%d")
    release_no_unprocessed = release["_source"]["release-id"]
    text_processing(title_unprocessed); text_processing(date_unprocessed); text_processing(release_no_unprocessed)

    iteration[:title] = title_unprocessed.strip
    iteration[:date] = date_unprocessed.strip

    if release_no_unprocessed == nil
      iteration[:release_no] = "nothing"
    else
      iteration[:release_no] = release_no_unprocessed.strip
    end

    body = Nokogiri::HTML(release["_source"]["body"]) #читаю содержание json как сайт, коем оно и является

    pdf_file = "" #есть два случая, где релиз содержит название файла pdf в особом классе (а текста релиза нету)
    dnd_drop_wrapper_text = body.search(".dnd-drop-wrapper").text
    if dnd_drop_wrapper_text != nil
      dnd_drop_wrapper_text.match?(".pdf")
      pdf_file << dnd_drop_wrapper_text.strip
    end

    credits_and_note = body.search(".dnd-atom-wrapper") #в этом классе содержатся картинки и пояснение к ним, по заданию не нужно - удаляю
    credits_and_note.each do |item|
      item.remove
    end
    body.to_a.reject! { |element| element.parent.nil? } #сохраняю изменения

    li_elem = body.search("li") #нахожу все элементы списка и делаю их явными для программы, так как далее не будет тэгов, а просто текст
    li_elem.each do |li|
      content = "*" + li.content
      content.sub!(/^\*\W+/, "*") if content.match?(/^\*\W+/) #рассматриваю единственный вариант, где строка начинается с "*" и после неё есть один и более символов, кроме [0-9a-zA-Z_]
      li.content = content
    end

    br_elem = body.search("br") #br элементы - это символ переноса на новую строку, так есть в форме релиза
    br_elem.each do |br|
      br.name = "p"
      br.content = "LINE_CUT#" #для дальнейшей замены на нужные символы
    end

    body_text = body.text
    if body_text.match?("LINE_CUT#")
      body_text.gsub!("LINE_CUT#", "\n")
    end

    result_text = ""

    array_of_text_elements = body_text.split(/\n/)
    array_of_text_elements.each do |element|
      text_processing(element)

      if element.match?(/^\s|[\r\n\t]|\s$/) #если strip нужен - я его применяю
        element.strip!
      end
    end

    array_of_text_elements.reject! do |element| #просматриваю каждый элемент массива и удаляю элемент при совпадении с правилом
      element == " " ||
        element == nil ||
        element == " " ||
        element == "" ||
        element == "text-only version of this release" ||
        element == "Printer Friendly Version" ||
        element == "Back to NASA Newsroom | Back to NASA Homepage" ||
        element == "For more information about Langley go to www.nasa.gov/langley" ||
        element == "For more information or to learn about other happenings at NASA`s Marshall Space Flight Center, visit NASA Marshall" ||
        element.match?(/\s?( -)?(- )?(– )?–?-?end-?–?( –)?( -)?(- )?\s?/i) && element.size < 12 ||
        element.match?(/\s?( -)?(- )?(– )?–?-?nasa-?–?( –)?( -)?(- )?\s?/i) && element.size < 12 ||
        element.match?(/For more information or to learn about other happenings at NASA`s Marshall Space Flight Center/) && element.size < 175 || #достаточно обозначить часть строки для её нахождения, указания размера строки делает удаление более безопасным
        element.match?(/NASA press releases and other information are available automatically by sending a blank e-mail/) && element.size < 270 ||
        element.match?(/To receive status reports and news releases issued from the Dryden Newsroom electronically, send a blank/) && element.size < 310 ||
        element.match?(/To receive status reports and news releases issued from the Kennedy Space Center Newsroom electronically, send a blank/) && element.size < 315 ||
        element.match?(/NASA Marshall Space Flight Center news releases and other information are available automatically by sending/) && element.size < 205 ||
        element.match?(/To unsubscribe, send an e-mail message with the subject line unsubscribe to msfc-request@newsletters.nasa.gov./) && element.size < 120 ||
        element.match?(/NASA ((Langley)?|(news)?) ((press)?|(releases)?|(news)?)( releases)? are available( automatically)? by sending an e-?mail message to Langley-news-request@lists.nasa.gov\s?with the word "?subscribe"? in the subject line. You will receive an e-?mail ((instructing)?|(asking)?) you to ((reply)?|(visit)?)( a link)? to confirm the action. To unsubscribe, send an e-?mail message to Langley-news-request@lists.nasa.gov with the word "?unsubscribe"? in the subject line./i) && element.size < 410  #чтобы не удалить строку, в которой есть еще информация помимо статичной строки, число после size = размер статичной строки + небольшой запас
    end

    array_of_text_elements.each_with_index do |element, index|
      item_text = element.strip

      if item_text.start_with?("-") || item_text.start_with?("·") || item_text.start_with?("•") || item_text.start_with?("›") || item_text.start_with?("o") #вариант, где список элемента не помещен в специальный тэг - и является простым текстом
        item_text.slice!(0)
        item_text = item_text.strip
        item_text.insert(0, "*")
        item_text.sub!(/^\*\W+/, "*") if item_text.match?(/^\*\W+/)
      elsif item_text.start_with?("*")
        item_text.sub!(/^\*\W+/, "*") if item_text.match?(/^\*\W+/)
      end

      if item_text.match?(/.*RELEASE:.*-/) && item_text.size < 40  ||
        item_text.match?(/.*ADVISORY:.*-/) && item_text.size < 40  ||
        item_text.match?(/.*Release:.*-/) && item_text.size < 40  || item_text.match?(/.*MEDIA ADVISORY:?.*-/) && item_text.size < 40
        release_number = element.split.pop #делю строку на массив слов, последний элемент массива - номер релиза
        text_processing(release_number)

        iteration[:release_no] = release_number.strip #вариант, где номер релиза помещается в параграф, существует в пару десятках мест, учитываю
        next
      end

      if item_text.start_with?("*") #если элемент текста - элемент списка
        if item_text == "*" #в случае, если забыли добавить текст к элементу списка, один раз такое было
          result_text << "\n"
          next
        end

        if not array_of_text_elements[index + 1].nil? #чтобы проверка не ушла туда, куда не нужно
          if !array_of_text_elements[index + 1].start_with?(/[*\-·•›o–]/) #если следующий элемент - не элемент списка, то делаю увеличенный отступ, в другом случае укороченный
            result_text << item_text + "\n\n"
          else
            result_text << item_text + "\n"
          end
        end
      else
        result_text << item_text + "\n\n"
      end
    end

    iteration[:article] = result_text.strip
    if !pdf_file.empty? && result_text.empty?
      iteration[:article] = pdf_file
    end
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
      bar = ProgressBar.new(array_of_releases.size, :bar, :percentage, :counter) #выбираю нужные элементы бара

      @all_months.each_with_index do |month, index|
        month_folder_path = year_folder + "/[#{index + 1}]##{month}"

        if !Dir.exist?(month_folder_path)
          Dir.mkdir(month_folder_path)
        end

        sleep_value = delay_value(array_of_releases.size, 1)
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
            sleep(sleep_value)

          end
        end
      end
    end
  end

end