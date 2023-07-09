#Сделать проверку, выходной ли сегодня и вывести ответ

time = Time.now
day = time.wday #что важно, начало недели с воскресенья! И заканчивается неделя субботой.

if day == 0 || day == 6 #эти числа - порядковый номер выходных в неделе
	puts "Today is not working day!"
else
	puts "Today is work day!"
end