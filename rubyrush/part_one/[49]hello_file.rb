#Напиcать программу, которая здоровается в файл hello.txt (пишет строку "Hello, file!" в него).

File.open("data/HIfile.txt", "w") { |file| file.write("Hello, file!")}