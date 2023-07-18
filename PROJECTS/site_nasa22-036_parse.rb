require "mechanize"
require "json"
require "date"

agent = Mechanize.new

json = agent.get("https://www.nasa.gov/api/2/ubernode/479003") #в этом json лежит всё нужное информационное наполнение

json_processing = JSON.parse(json.body) #для возможности работать с информацией

result_hash = {title: 0, date: 0, release_no: 0, article: 0}
result_hash[:title] = json_processing["_source"]["title"] #заполняю нужной информацией созданный по образцу хэш
result_hash[:date] = Date.parse(json_processing["_source"]["promo-date-time"]).strftime("%Y-%m-%d")
result_hash[:release_no] = json_processing["_source"]["release-id"]

paragraphs = Nokogiri::HTML(json_processing["_source"]["body"]).search("p, li") #текст находится в этих двух тэгах, их и беру
paragraphs.at("//text()[contains(.,\"-end-\")]").remove #удаляю ненужный текст

article = ""
paragraphs.each do |paragraph| #прохожусь по всему тексту, а именно по каждому тегу в отдельности
  if paragraph.name == "li" #если попадается элемент списка, а они идут друг за другом - отступ не нужен
    article += "* " + paragraph.text
  else
    article += paragraph.text + "\n"
  end
end

result_hash[:article] = article

puts JSON.pretty_generate(result_hash)