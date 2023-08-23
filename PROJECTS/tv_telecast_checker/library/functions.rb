def month_switch_language(month)
  months_hash = {
    "января" => "January",
    "февраля" => "February",
    "марта" => "March",
    "апреля" => "April",
    "мая" => "May",
    "июня" => "June",
    "июля" => "July",
    "августа" => "August",
    "сентября" => "September",
    "октября" => "October",
    "ноября" => "November",
    "декабря" => "December"
  }

  return months_hash[month] if months_hash.include?(month)
end

def processing_day(html)
  schedule_units = html.search(".schedule-unit") #тут я помещаю в переменную все контейнеры класса `schedule-unit` (в этом классе находятся блоками данным о канале и что на нем идет в ближайшее время)

  index = 0 #нужно для цикла
  hash_tv = Hash.new

  while index < schedule_units.size #условие: пока индекс меньше, чем количество блоков с информацией о каналах - нужна их обработка (логично, ведь я хочу все доступные блоки записать)
    schedule_unit = schedule_units[index] #тут происходит конкретизация, из всех доступных блоков я выбираю конкретный (по счету равный index)

    channel_name = schedule_unit.at_css("a").text
    titles = schedule_unit.search(".anons-pop").map { |element| element.text } #узнаю названия телепередач по особому классу, он есть не везде, поэтому ниже добавляю дополнительную проверку
    titles = schedule_unit.search("a").map { |element| element.text } if titles.empty?
    times = schedule_unit.search(".b-time").map { |element| element.text } #информация о времени начала телепередач, она находится в классе b-time

    (titles.size).times do #связываю с правильной принадлежностью к каналу массивы телепередач и времени их начала
      hash_tv[channel_name] = [titles[1..titles.size], times[1..times.size]]
    end

    index += 1
  end

  return hash_tv
end

def processing_all_days(document)
  days = document.at_css(".days-container").search("li") #в этом классе и далее элементах списка лежит название дня и ссылка на расписание по нему
  days_links = {}
  counter = 0
  days.each do |item|
    day_info = (item.text).sub!(/[а-я]+\s/i, "") #удаляю первое слово, оно обозначает день недели на русском, но это не нужно
    day_info = day_info.split #по итогу получается такого типа информация `7 января`, делю строку на день месяца и название месяца
    day_info[1] = month_switch_language(day_info[1]) + " #{Time.new.strftime("%Y")}" #меняю строку с названием месяца на английский для сравнения дат и добавляю год
    day_info = day_info.join(" ") #меняю тип на строку

    if Time.parse(day_info) > Time.new #сайт предоставляю возможность просмотра предыдущих дней, а я считаю нужным показать только будущие, тут отсеивание происходит
      days_links[counter] = [day_info, item.at_css("a")["href"]] #заполняю хэш массивами с информацией по дням, которые содержат название дня и ссылку на этот день
      counter += 1
    end
  end

  return days_links
end