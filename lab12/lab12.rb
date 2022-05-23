require 'openssl'

puts (key = OpenSSL::PKey::RSA.new 2048)
puts text = 'Hello from Darya'
puts (signature = key.sign 'SHA256', text)
if key.verify 'SHA256', signature, text
  puts 'Valid'
else
  puts 'Invalid'
end
