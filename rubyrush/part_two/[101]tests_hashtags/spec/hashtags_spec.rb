require "hashtags"

describe "hashtags" do
  it "return only 1 hashtag" do
    expect(hashtags("wonderful language #ruby")).to eq ["#ruby"]
  end

  it "return some hashtags" do
    expect(hashtags("today i work in #ruby #working")).to eq ["#ruby", "#working"]
  end

  it "return only russian hashtag" do
    expect(hashtags("можно знать, а можно нет, но manjaro крут #линукс")).to eq ["#линукс"] #тест не прошел, потому что в проверке указано, что после решетки могут идти нижний/верхний регистр английского алфавита или цифры, но не русские буквы
  end

  it "return only underline hashtag" do
    expect(hashtags("тесты это просто нечто #ruby_tests")).to eq ["#ruby_tests"]
  end

  it "return hashtag with minus only" do
    expect(hashtags("most of people can do something beautiful #peoples-can-beautiful")).to eq ["#peoples-can_be-beautiful"] #тест не прошел, знак `-` недопустим, его проверка не учитывает и в результате не покажет, он будет как конец строки
  end

  it "dont return `?`" do
    expect(hashtags("may us be lonely in this universe? #lonely?")).to eq ["#lonely"]
  end

  it "dont return `!`" do
    expect(hashtags("exists many wonderful locales! #wonderful_world!")).to eq ["#wonderful_world"]
  end
end