#1. просмотрел информацию о github, показанные действия в уроке уже были совершены
#2. улучшить программу, чтобы вместо слова of diamonds выводился символ
# соответствующей масти

values = ['2','3','4','5','6','7','8','9','10','J','Q','K','A']
suits = ["Diamonds", "Hearts", "Clubs", "Spades"]
suits_only_symbols = ["♦", "♥", "♣", "♠"]


puts "#{values.sample} of #{suits_only_symbols.sample}"
