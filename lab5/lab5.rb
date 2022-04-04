require './lab5/func5'
require './lab2/functions_2'
require_relative 'func5'
require 'matrix'


time = Time.now
message = 'qwertyuiopas'
key = 4
puts 'Маршрутная перестановка Скитала: запись – по строкам, считывание – по столбцам таблицы'
print 'Encrypted text: '
  puts a = Func5.encrypt_skitala(message, key)
time1 = Time.now
puts "#{time1 - time} sec"
  print 'Decrypted text: '
  puts Func5.decrypt_skitala(a, key)
time2 = Time.now
puts "#{time2 - time1} sec"


time = Time.now
puts 'Множественная перестановка по ключевым словам имени и фамилии'
surname = Func5.order_of_letters('astrouky') #[0 4 5 3 2 6 1 7]
name = Func5.order_of_letters('dash') #[1 0 3 2]
text = 'This is a message for encryption'
  a = Func5.encrypt_change(text, name, surname)
puts "Encrypted message: #{a}"
time1 = Time.now
puts "#{time1 - time} sec"
  puts "Decrypted message: #{Func5.decrypt_change(a, name, surname)}"
time2 = Time.now
puts "#{time2 - time1} sec"
