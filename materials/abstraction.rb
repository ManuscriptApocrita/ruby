class Cook #создам класс повар, и что действительно важно в его описании - его ФИ и навыки, интересующие по задаче
  def initialize(first_name, last_name, udon, sushimi)
    @first_name = first_name
    @last_name = last_name
    @udon = udon
    @sushimi = sushimi
  end

  def what_can_cook?
    if @udon && @sushimi
      puts "#{@first_name} #{@last_name} CAN cook udon and suhimi!"
    elsif @udon == false && @sushimi == false
      puts "#{@first_name} #{@last_name} CAN`T cook udon and suhimi!"
    else
      if @udon == true && @sushimi == false
        puts "#{@first_name} #{@last_name} CAN cook only udon..."
      else
        puts "#{@first_name} #{@last_name} CAN cook only suhimy..."
      end
    end
  end
end

cook1 = Cook.new("Enriko", "Haarby", true, true)
cook2 = Cook.new("Elpacho", "Naanoske", true, false)

cook1.what_can_cook?
cook2.what_can_cook?

#По итогу можно сказать, что я использовал абстракцию и использовал минимальное количество ресурсов
# для идентификации навыка, поля с именем и фамилией нужны для определения конкретного человека, а
# методы позволяют понять в другой части программы, что люди в базе умеют делать.