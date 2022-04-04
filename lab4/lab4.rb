require './lab4/func4'
require './lab2/functions_2'
require_relative 'func4'

#подстановочные шифры моно и поли
puts text = Functions_2.clean_text(Functions_2.read_txt_file_to_string('lab4/bel.txt'))
time = Time.now
a = Func4.encrypt_sdvigom(text, 5)
puts "  Encrypted message: #{a}"
time1 = Time.now
puts "#{time1 - time} sec"
puts "  Decrypted message: #{Func4.decrypt_sdvigom(a, 5)}"
time2 = Time.now
puts "#{time2 - time1} sec"

time = Time.now
text2 = 'дзе захоўваецца значная доля паступовасьці'
puts " Start message 2: #{text2}"
v = Func4.encrypt_vijiner('астровская', text2)
puts "  Encrypted message: #{v}"
time1 = Time.now
puts "#{time1 - time} sec"
puts "  Decrypted message: #{Func4.decrypt_vijiner('астровская', v)}"
time2 = Time.now
puts "#{time2 - time1} sec"

