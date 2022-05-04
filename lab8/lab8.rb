require 'openssl'
class BBS #генератором на основе квадратичных вычетов
  class << self
    def generate_first_number(value)
      found = false
      i = value + 1
      until found # until = while !
        if i % 4 == 3
          found = true
        else
          i += 1
        end
      end
      return i
    end

    def generate_next_number(value, m)
      return value**2 % m
    end

  end
end

# Crypto Lab 8
def read_key(key_file)
  File.read(key_file).split(',').map { |x| x.to_i }.pack('c*')
end

# BBS generator
def bbs_generator
  p = BBS.generate_first_number(1499)
  q = BBS.generate_first_number(p)
  m = p * q
  puts "M = #{m}"

  num = 256

  (1..4).each do |i|
    num = BBS.generate_next_number(num, m) # num,m
    puts "#{i}: #{num}"
  end
end

# RC4
def encrypt_RC4
  des = OpenSSL::Cipher::Cipher.new('rc4')
  des.encrypt
  des.key = read_key('lab8/key_rc4.bin')

  # Now we go ahead and encrypt our plain text.
  cipher = des.update("This is line 1\n")
  cipher << des.update("This is some other string without linebreak.")
  cipher << des.update("This follows immediately after period.")
  cipher << des.update("Same with this final sentence.")
  cipher << des.final

  cipher64 = [cipher].pack('m')
  cipher64
end

def decrypt_RC4(cipher64)
  decode_cipher = OpenSSL::Cipher::Cipher.new('rc4')
  decode_cipher.decrypt
  decode_cipher.key = read_key('lab8/key_rc4.bin')
  plain = decode_cipher.update(cipher64.unpack('m')[0])
  plain << decode_cipher.final
  plain
end

  puts 'Crypto Lab 8'

  puts ' BBS generator'
  bbs_generator

  puts "\n Encryption RC4"
  txt = encrypt_RC4
  puts txt

  puts "\n Decryption RC4"
  puts decrypt_RC4(txt)
