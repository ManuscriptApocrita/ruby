class Book < Product
  def initialize(setting)#инициализация с входными данными
    super
    @title = setting[:title]
    @genre = setting[:genre]
    @author = setting[:author]
  end

  attr_reader :title, :genre, :author #позволяет прочесть переменные инициализации
  attr_accessor :title, :genre, :author #позволяет перезаписать переменные инициализации

  def update(setting) #метод смены значения переменной инициализации с помощью метода
    super

    @title = setting[:title] if setting[:title]
    @genre = setting[:genre] if setting[:genre]
    @author = setting[:author] if setting[:author]
  end

  def self.from_file(path_file)  #назначаю переменные опираясь на строки файла, а прежде убираю пробелы в тексте
    file = File.readlines(path_file, encoding: 'UTF-8').map { |line| line.chomp }
    self.new(title: file[0], genre: file[1], author: file[2], price: file[3], stock_item: file[4])
  end

  def to_s#к выводу можно добавить все данные
    puts "Book #{@title}, #{@genre}, author - #{@author}, #{super} "
  end
end
