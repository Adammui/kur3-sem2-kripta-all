require './lab2/functions_2'
require 'squid'
require_relative 'functions_2'

ru = File.open('lab2/ru.txt')
ru_text = ru.read

ge = File.open('lab2/ge.txt')
ge_text = ge.read
puts hash = Functions_2.letters_count(ge_text)

# bin_file = File.new("bin.bin","w+") # I understand w+ may not be the correct option
# bin_file.puts(ge_text.unpack('b*'))
# bin_file.close

bin = File.open('lab2/bin.bin')
bin_text = bin.read

Prawn::Fonts::AFM.hide_m17n_warning = true
Prawn::Document.generate 'lab2/web graph.pdf' do
  chart letters: hash
end

puts '1/ Энтропия немецкого:'
puts Functions_2.shannon_entropy(ge_text)
puts 'Энтропия русского:'
puts Functions_2.shannon_entropy(ru_text)
puts '2/ Энтропия бинарного:'
puts Functions_2.shannon_entropy(bin_text)
puts '3/ Колво информации в моем фио'
fio = 'Astrouskaya Darya Aleksandrouna'
puts Functions_2.information_amount(fio)
puts 'in ASCII'
puts Functions_2.information_amount_ascii(fio)
puts '4/ with mistake = 0.1, 0.5, 1.0'
puts Functions_2.information_amount_w_mistake(fio, 0.1)
puts Functions_2.information_amount_w_mistake(fio, 0.5)
puts Functions_2.information_amount_w_mistake(fio, 1)
