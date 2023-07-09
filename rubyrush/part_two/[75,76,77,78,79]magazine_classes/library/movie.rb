class Movie < Product
  def initialize(setting)#инициализация с входными данными
    super
    @title = setting[:title]
    @year = setting[:year]
    @director = setting[:director]
  end

  attr_reader :title, :year, :director #позволяет прочесть переменные инициализации
  attr_accessor :title, :year, :director #позволяет перезаписать переменные инициализации

  def update(setting) #метод смены значения переменной инициализации с помощью метода
    super
      @title = setting[:title] if setting[:title]
      @year = setting[:year] if setting[:year]
      @director = setting[:director] if setting[:director]
  end

  def self.from_file(path_file) #назначаю переменные опираясь на строки файла, а прежде убираю пробелы в тексте
    file = File.readlines(path_file, encoding: 'UTF-8').map { |l| l.chomp }
    self.new(title: file[0], director: file[1], year: file[2], price: file[3], stock_item: file[4])
  end

  def to_s #к выводу можно добавить все данные
    puts "Movie #{@title}, #{year}, director - #{@director}, #{super} "
  end

end
