class Wish #В подсказе увидел способ - сделать класс использование которого вяжется только с xml обработкой, интересно
  def initialize(setting)
    @date = Date.parse(setting.attributes["date"])
    @text = setting.text.strip #strip форматирует строку в строку без `мусора`
  end

  def overdue? #метод сравнения переменой даты с текущим днем
    @date < Date.today
  end

  def to_s #В таком виде выводится информация о классе
    "#{@date.strftime('%d.%m.%Y')}: #{@text}"
  end
end
