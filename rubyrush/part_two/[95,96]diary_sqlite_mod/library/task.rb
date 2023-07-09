require "date"

class Task < WriteRead
  def initialize
    super
    @due_date = Time.now
  end

  def read_from_console
    puts "What task would you like to plan?"

    @text = gets.chomp

    puts "Enter the time frame in the format: DD.MM.YYYY " \
    "for example 01.01.1999"

    user_input = gets.chomp

    while
      if user_input.match(/^[0-9]{2}\.[0-9]{2}\.[0-9]{4}/) #проверка регулярным выражением на правильность вводимой даты, круто!
        break
      else
        puts "Input correct answer..."
        user_input = gets.chomp
      end
    end

    @due_date = Date.parse(user_input)
  end

  def to_strings
    deadline = "#{@due_date.strftime("%d.%m.%Y")}"
    time_string = "#{@created_at.strftime("%d.%m.%Y, %H:%M")}"

    return ["Task", @text, deadline, time_string] #сохранение в данном порядке для удобства сохранения этих переменных в базу sqlite
  end
end
