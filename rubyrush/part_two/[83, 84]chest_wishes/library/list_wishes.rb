def read_wishes
  file_name = (File.dirname(__FILE__)).chomp!("library") + "/data/chest.xml" #удаляю название лишней папки к файлу

  unless File.exist?(file_name) #если файла нету - нечего читать
    abort "File not found..."
  end

  file = File.new(file_name)
  xml_document = REXML::Document.new(file)
  file.close

  result = []

  xml_document.elements.each("wishes/wish") do |element| #в массив сохраняются экземпляры класса с данными из xml ячеек
    result << Wish.new(element)
  end

  puts "These wishes should already be fulfilled by today:" #печатает экземпляр, если дата меньше сегодняшней
  result.each do |element|
    puts element if element.overdue?
  end

  puts "\nNeed to be done:"
  result.each do |element| #наоборот - печатает если дата больше сегодняшней
    puts element unless element.overdue?
  end
end