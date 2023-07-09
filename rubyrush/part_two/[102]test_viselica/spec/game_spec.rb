#Сделать интегральный тест игры "виселица"
# протестировать класс Game: написать два теста, первый из которых симулирует выигрышное поведение пользователя,
# а второй — проигрыш. Проверить, что игра перешла в нужное состояние.

require "game"

describe Game do
  it "win result" do #укладываюсь в пять попыток и побеждаю, отгадывая слово
    game = Game.new
    game.game_word("common")

    game.check_result("c")
    game.check_result("o")
    expect(game.status).to eq 0 #убеждаюсь, что статус игры не изменился на победу, ведь я же не угадал слово
    game.check_result("common")
    expect(game.status).to eq 1 #после угаданного слова статус изменился, регистрирую этот момент, все работает как нужно
  end

  it "lose result" do #не укладываюсь в пять попыток и проигрываю
    game = Game.new
    game.game_word("unless")

    game.check_result("e")
    game.check_result("d")
    game.check_result("a")
    game.check_result("g")
    game.check_result("c")

    expect(game.status).to eq 2 #все верно, пять попыток было использовано, и они не привели к отгадыванию целого слова, поэтому - поражение
  end
end