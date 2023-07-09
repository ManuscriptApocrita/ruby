class Note < WriteRead
  def read_from_console
    puts "New note (write until string `end`):"
    line = nil

    while
      if line != "end"
        line = gets.chomp
        @text << line
      end
    end

    @text.pop #на этом моменте пользователь прошел проверку, но нужно удалить слово `end`, оно лишнее
  end

  def to_strings
    time_string = "Created: #{@created_at.strftime("%d.%m.%Y, %H:%M")}"
    @text.unshift(time_string) #указываю, что прежде текста будет строка со временем
  end
end
