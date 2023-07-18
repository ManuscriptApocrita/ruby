require "mechanize"

def string_cutter(array_chars, number) #беру на вход символы текста без отступов в массиве и число
  array_chars.each_slice(number) do |group_chars| #число определяет, на каком символе по счету будет перенос
    puts group_chars.join
  end
end

agent = Mechanize.new #взаимодействие с интернетом!
wiki_main_page = agent.get("https://ru.wikipedia.org/") #загружаю html форму в переменную

puts "Введите поисковой запрос!"
user_input = gets.chomp

form = wiki_main_page.form_with(id: "searchform") #ищу такую форму, где есть поисковое поле
search_field = form.field_with(id: "searchInput") #присваиваю переменной поле формы с поисковой строкой
search_field.value = user_input #заполняю строку введенным пользователем значением

result_search_page = agent.submit(form, form.buttons.first) #Поиск состоялся, тут указывается, что на конкретной форме нажимается кнопка

abort "Соответствий по запросу не найдено..." if result_search_page.at(".mw-search-nonefound") != nil #данный класс выводится на странице в случае отсутствия соответствий по запросу, если по такой выборке будет результат nil, то результаты поиска есть, != nil результатов нет

result_search_elements = result_search_page.at(".mw-search-results").search("li").first(8) #ищу в контейнере результатов поиска первые 8 (актуальный поиск), доступно до 20, но более не нужно

system("cls") || system("clear")
puts "Нашлось #{result_search_elements.size} ответов:"

title_array = Array.new

result_search_elements.each_with_index do |item, index|
  element = item.at(".searchResultImage-text") #эта переменная берёт итерируемый текст элемента списка
  title = element.at("a").attributes["data-prefixedtext"].value #в нескольких местах был заголовок, но я выбрал отсюда
  text = (element.at(".searchresult").text).split("") #здесь само содержание заголовка, перевожу его в массив без пробелов

  puts "__________________________________________________________________________"
  puts "#{index + 1}. #{title}"

  title_array << title #в дальнейшем нужно для перехода к конкретному элементу

  string_cutter(text, 75)
  puts "\n"
end

puts "Выберите желаемый пункт..."
user_input = nil

until (1..(result_search_elements.size)).include?(user_input)
  user_input = gets.to_i
end

search_title = (title_array[user_input - 1])
href = result_search_page.at("a[data-prefixedtext=\"#{search_title}\"]").attributes["href"] #подставляю выбранное пользователем и ищу конкректниый элемент на странице результатов поиска, он должен быть, беру ссылку

if href.nil?
  abort "Ссылка не найдена!"
else
  result_element_form = agent.get("https://ru.wikipedia.org" + href) #иду на адрес, который есть в указанном пользователем элементе
end

body = result_element_form.search(".mw-parser-output") #этот класс это контейнер, содержащий результат поиска - вся информация здесь

body = body.search("p") #нужны параграфы, основная информация тут

system("cls") || system("clear")

puts "Информация по элементу поиска: \n\n"

body.each do |paragraph| #вывожу ранее собранные параграфы поочередно
  string = (paragraph.text).split("")
  string_cutter(string, 100)
  puts
end