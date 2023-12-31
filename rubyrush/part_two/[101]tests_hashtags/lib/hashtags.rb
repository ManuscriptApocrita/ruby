#Вынести функционал поиска хэштегов в строке в метод hashtags. Он на вход принимает строку, а возвращает массив хэштегов.
# Написать набор тестов на этот метод. Вот список проверок:
# 1 Захватывается 1 хэштег
# 2 Захватывается несколько хэштегов
# 3 Захватывается хэштег на русском
# 4 Захватывается хэштег с подчеркиваниями
# 5 Захватывается хэштег с минусами
# 6 Не захватывается знак вопроса
# 7 Не захватывается восклицательный знак

require 'rspec'

def hashtags(string)
  string.scan(/#\w+/)
end