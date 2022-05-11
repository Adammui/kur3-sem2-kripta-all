
# в простейшем случае принимается z = 6 (для кодировки Base64) и z = 8 (для кодировки ASCII);
# вычисление нормальной последовательности (открытого ключа);
# зашифрование сообщения, состоящего из собственных фамилии, имени и отчества;
# расшифрование сообщения;

# размерность блока и ключа
z = 8
# текст для зашифрования
# открытый ключ
e = [62, 93, 186, 403, 417, 352, 315, 210]
d = [2, 3, 6, 13, 27, 52, 105, 210]

n = 420
a = 31
a_obr = 271

text_for_encryption = '_MY_FIO__MY_FIO__MY_FIO__MY_FIO_' # lenght 32

# turns [1, 1, 1, 0, 1] to [0, 0, 0, 1, 1, 1, 0, 1]
def add_zeros(arr)
  while true
    if arr.length == 8
      return arr
    else
      arr.prepend "0"
    end
  end
end

def encrypt(text, z, e)
  textarr = text.split('')
  res = '' # результат шифрования

  (0..(textarr.length / z) - 1).each do |i|
    block = []
    prom_res = []
    (0..7).each do |j|
      prom_res = []
      block << textarr[i * 8 + j].ord # ord возвращает ASCII код символа / chr - обратная операция
      block.each do |letter|
        prom_res << letter.to_s(2)
      end
    end

    # ["1000010", "1101100", "1101001", "1101110", "1101111", "1110110", "1011111", "1000001"] вот такая шняга это одно слово
    print prom_res
    print " -- one block with 8 letters\n"

    # [0, "1", "0", "0", "0", "0", "1", "0"] -- code
    prom_res.each do |code|
      sum = 0
      code_arr = code.split('')
      code_arr_with_zeros = add_zeros(code_arr)

      print code_arr_with_zeros
      print " -- one symbol in bytecode \n"

      (0..7).each do |j|
        # puts j.to_i
        index = code_arr_with_zeros[j].to_i
        # puts index
        if index == 1
          sum += e[j]
        end
      end
      res += sum.to_s
      res += ' '
    end

    # puts ''
    # print block
  end

  return res
end

def dec(num)
  arr = []
  d = [2, 3, 6, 13, 27, 52, 105, 210]
  (1..8).each do |i|
    if (num - d[8 - i]) >= 0
      num -= d[8 - i]
      arr.prepend "1"
    else
      arr.prepend "0"
    end
  end

  help_arr = []
  (0..7).each do |i|
    help_arr.append (arr[7 - i].to_i * (2 ** i)).to_i
  end

  return help_arr.sum.chr
end

def decrypt(encrypted_text, a_obr)
  sums = encrypted_text.split(' ')

  sums.each do |sym|
    s1 = (sym.to_i * a_obr) % 420
    print dec(s1)
  end
end

print "e = "
print e
print "\nd = "
print d
print "\n\n"

# шифруемый текст / размер ключа и блоков / ключ
encrypted_text = encrypt(text_for_encryption, z, e)
print encrypted_text

puts "\n\n"
decrypt(encrypted_text, a_obr)