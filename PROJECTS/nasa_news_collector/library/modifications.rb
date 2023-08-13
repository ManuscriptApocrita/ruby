class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end
end

def text_processing(element)
  if element != nil
    element.delete!("\r\n\t") if element.match?(/\r\n\t/)
    element.gsub!("", " ") if element.match?("") #в одном релизе присутствует этот странный символ
    element.gsub!("”", "\"") if element.match?("”") #привожу все кавычки в один стиль
    element.gsub!("“", "\"") if element.match?("“")
    if element.match?(/[`'‘’]/)
      element.gsub!(/''/, "\"") if element.match?(/''/) #почему-то человек решил поставить четыре символа огибая слово вместо двух...
      element.gsub!(/(?<=\S)['‘’](?=\S)/, "`") if element.match?(/(?<=\S)['‘’](?=\S)/) #проверяется, есть ли слева и справа от указанных символов по одному любому непробельному символу
      element.gsub!(/(?<=^|\s|")[`'‘’]/, "\"") if element.match?(/(?<=^|\s|")[`'‘’]/) #проверяется, есть ли перед указанными символами начало строки, пробел, или "
      element.gsub!(/['‘’](?=\s|$)/, "\"") if element.match?(/['‘’](?=\s|$)/) #проверяется, есть ли после указанных символом конец строки или пробел
    end
    element.gsub!(/['‘’]/, "`") if element.match?(/['‘’]/) #если вышеописанные правила не сработали
    element.gsub!("\u202F", " ") if element.match?("\u202F") #NNBSP, ( ) неразрывный пробел
    element.gsub!("\u00A0", " ") if element.match?("\u00A0") #NBSP, ( ) тоже неразрывный пробел
    element.gsub!(/(?<=")\u200B/, "") if element.match?(/(?<=")\u200B/) #рассматривается случай, когда слева от ZWSP кавычка, в этом случае нужно аннулировать этот символ - убираю
    element.gsub!("\u200B", " ") if element.match?("\u200B") #ZWSP, (​) невидимый символ, который делает пробел без видимого отступа в тексте
    element.gsub!("\u2028", "") if element.match?("\u2028") #LSEP, используется для разделения строк
    element.gsub!("\u00AD", "") if element.match?("\u00AD") #SHY, (­) позволяет браузеру переносить слова на новую строку, если это нужно. в данном случае оно портит текст
    element.gsub!(/ +/, " ") if element.match?(/ +/)
  end
end

def delay_value(elements_length, mode)
  if elements_length > 1000
    sleep_value = 0.003
  elsif elements_length < 1000 && elements_length > 500
    sleep_value = 0.012
  elsif elements_length < 500 && elements_length > 200
    sleep_value = 0.016
  elsif elements_length < 200 && elements_length > 100
    sleep_value = 0.019
  elsif elements_length < 100
    sleep_value = 0.198
  end

  if mode == 1
    if elements_length < 100
      sleep_value = sleep_value - 0.05
    else
      sleep_value = sleep_value - 0.004
    end
  end

  return sleep_value
end

def remaining_time_analysis(last_update_date)
  time_now = Time.new #создаю переменную с временем, далее буду брать информацию о нём по части
  logic_answer = ""

  if time_now.year > last_update_date.year #первое, что нужно понять - год, если год последнего обновления меньше, чем сегодняшний - обновление можно выполнить, месяц прошел точно
    logic_answer << "you may do update!".colorize(32)
  else
    if (time_now.month - last_update_date.month) > 1 #дальше если разница настоящего месяца и последнего обновления больше одного - базу можно обновлять
      logic_answer << "you may do update!".colorize(32)
    end

    if (time_now.month - last_update_date.month) == 1 #если разница в один месяц, продолжаю проверку
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

  return logic_answer
end