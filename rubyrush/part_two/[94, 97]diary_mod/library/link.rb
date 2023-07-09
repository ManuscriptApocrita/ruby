class Link < WriteRead
  def initialize
    super
    @url = ""
  end

  def read_from_console #метод опроса пользователя на соответствующие классу поля
    puts "input link adress:"
    @url = gets.chomp

    puts "Explanation for the link..."
    @text = gets.chomp
  end

  def to_strings
    time_string = "Created: #{@created_at.strftime("%d.%m.%Y, %H:%M")}"
    [@url, @text].unshift(time_string) #сохранение в данном порядке столбцом
  end
end
