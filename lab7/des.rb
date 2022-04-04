require 'openssl'

class String
  def encrypt(key)
    cipher = OpenSSL::Cipher.new('DES').encrypt
    cipher.key = key
    cipher.update(self) + cipher.final
  end

  def decrypt(key)
    cipher = OpenSSL::Cipher.new('DES').decrypt
    cipher.key = key
    cipher.update(self) + cipher.final
  end
end

keygen = OpenSSL::Cipher.new('DES').encrypt
key = keygen.random_key
puts "key: #{key}"

encrypted = 'Astrousk'.encrypt(key)
puts "encrypted text: #{encrypted}"

decrypted = encrypted.decrypt(key)
puts "decrypted text: #{decrypted}"


