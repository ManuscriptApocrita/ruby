#1. Написать программу "Монетка"
# 2. Модифицировать прогроамму так, чтобы иногда выпадало ребро. Вероятность 1/10

#в случае, если результатом "rand" будет 10, то вероятность один к десяти выполнится!
if rand(11) == 10
	puts "The coin is on edge!"
else #если вероятность на "ребро" не выполнилась - приводится в исполнение обычный исход событий
	if rand(2) == 1 #верхний порог обозначается "цифра + 1", и то что меньше указанного числа крутится в программе, т.е 0 или 1, не включая двойку
		puts "Eagle!"
	else
		puts "Tail!"
	end
end