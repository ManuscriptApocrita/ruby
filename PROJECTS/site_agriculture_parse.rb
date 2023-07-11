require "mechanize"
require "json"

agent = Mechanize.new

html_page = agent.get("https://agriculture.house.gov/news/documentsingle.aspx?DocumentID=2106/")

information = {title: 0, date: 0, location: 0, article: 0}

#загружаю в хэш заголовок и убираю ненужные символы
information[:title] = html_page.title.gsub(/[\r\n\t]/, "")

#время
published_time = html_page.search('meta').find { |tag| tag["property"] == "article:published_time" }

information[:date] = published_time["content"]

#заголовок
top_news = html_page.search(".topnewstext").text #тут есть и дата, но с меты надежнее загрузить, что и было сделано выше

title = top_news.split(/[^\p{L}]+/) #сплит разделяет по паттерну так, чтобы удалялись символы ненужные (все) и остается просто текст

title.shift #лишний пустой элемент

information[:location] = title[0]

#артикл
paragraphs = html_page.search(".bodycopy") #подгружаю класс, который содержит нужный body
paragraphs.xpath('//p[text()="###"]').remove #удаляю три решетки (в конце текста данным случаем есть), если они есть
paragraphs = paragraphs.css("div p") #беру все параграфы

text = ""

def processing(block) #чтобы не дублировать код
  paragraph = block.text
  paragraph.delete!("\u00A0")
  paragraph.gsub!("\"", "")
  paragraph.gsub!(/[\r\n\t]/, "")
  paragraph
end

paragraphs.each_with_index do |block, index| #индекс для определения итерации и непозволения в конце добавления ненужных отступов
  if index == paragraphs.size - 1
    text += processing(block)
  else
    text += processing(block) + "\n\n" #расширяю ранее подготовленную строку, пошагово удаляя с каждого параграфа кавычки и ненужные символы, а так же неразрывный пробел
  end
end

information[:article] = text.sub(" ", "") #еще остается первый пробел в тексте

puts JSON.pretty_generate(information)