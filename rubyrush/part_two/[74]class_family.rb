#Создать класс Родителя и унаследовать от него класс Ребёнка. Сделать так.
#чтобы родителю при создании можно было задать имя, а с помощью метода
#name у экземпляра класса можно было это имя посмотреть. Создать метод
#послушности, родители - послушные, дети - нет

class Father
  def initialize(name)
    @name = name
  end

  def obedient?
    true
  end

  def name?
    return @name
  end
end

class Child < Father
  def name?
    super
  end

  def obedient?
    false
  end
end

parent = Father.new("Grigory")
son = Child.new("Nikolya")
daughter = Child.new("Vasilisa")

puts "#{parent.name?} obedient? #{parent.obedient?}"
puts "#{son.name?} obedient? #{son.obedient?}"
puts "#{daughter.name?} obedient? #{daughter.obedient?}"


