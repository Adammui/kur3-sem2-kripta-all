require 'openssl'
require 'elgamal'

# y ≡ ax mod n
def func(a, x, n)
  y = (a**x) % n
  return y
end

res_arr = []

(1..7).each do |i|
  begin_time = Time.now
  func(5, 10**i, 2**100)
  end_time = Time.now
  # puts "Y = (#{5}**#{10**i})mod #{2**100}"
  res_arr.append(end_time - begin_time)
end

puts 'Time array'
print res_arr
print "\n\n"

# RSA
puts 'RSA'
key = OpenSSL::PKey::RSA.new(1024)
puts encrypted_string = key.public_encrypt('MY_FIO', OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)
puts decrypted_string = key.private_decrypt(encrypted_string, OpenSSL::PKey::RSA::PKCS1_OAEP_PADDING)
print "\n"

# El Gamal
puts 'El Gamal'
keypair = ElGamal::KeyPair.new
pub_key, priv_key = keypair.generate

encrypted_num = pub_key.encrypt(349330)
decrypted_num = priv_key.decrypt(encrypted_num)

puts priv_key
puts pub_key

puts decrypted_num
