
def phenomena(cloudiness, precipitation)
  case cloudiness.to_i
  when -1 then print "туман"
  when 0 then print "ясно"
  when 1 then print "малооблачно"
  when 2 then print "облачно"
  when 3 then print "пасмурно"
  end

  print ", "

  case precipitation.to_i
  when 3 then puts "смешанные"
  when 4 then puts "дождь"
  when 5 then puts "ливень"
  when 6,7 then puts "снег"
  when 8 then puts "гроза"
  when 9 then puts "нет данных"
  when 10 then puts "без осадков"
  end
end

def times_day(tod)
  if tod.to_i == 0
    puts "Ночью:"
  elsif tod.to_i == 1
    puts "Утром:"
  elsif tod.to_i == 2
    puts "Днем:"
  elsif tod.to_i == 3
    puts "Вечером:"
  end
end