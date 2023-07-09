class WriteRead #основной метод-родитель остальных классов папки либрари
  def initialize
    @created_at = Time.now
    @text = []
  end

  def save #сохранение! перебирается массив метода, каждый элемент записывается в файл
    file = File.new(file_path, "w:UTF-8")
    to_strings.each {|string| file.puts(string)}
    file.close
  end

  def file_path
    current_path = File.dirname(__FILE__).chomp!("library") + "storage" #делаю дорожку к отдельной папке
    file_time = @created_at.strftime("%Y-%m-%d__%H-%M")
    return "#{current_path}/#{self.class.name}_#{file_time}.txt" #путь в котором должно сохранится + имя используемого класса + время создания
  end

  def read_from_console
    #нужно классу-ребёнку
  end

  def to_strings
    #нужно классу-ребёнку
  end
end
