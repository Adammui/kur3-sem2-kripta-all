require 'ecdsa'
require 'securerandom'
require 'digest/sha2'

group = ECDSA::Group::Secp256k1
private_key = 1 + SecureRandom.random_number(group.order - 1)
puts 'private key: %#x' % private_key

public_key = group.generator.multiply_by_scalar(private_key)
puts 'public key: '
puts ' x: %#x' % public_key.x
puts ' y: %#x' % public_key.y

public_key_string = ECDSA::Format::PointOctetString.encode(public_key, compression: true)
public_key = ECDSA::Format::PointOctetString.decode(public_key_string, group)

puts message = 'Astrouskaya Darya'
puts digest = Digest::SHA2.digest(message)
signature = nil
while signature.nil?
  temp_key = 1 + SecureRandom.random_number(group.order - 1)
  signature = ECDSA.sign(group, private_key, digest, temp_key)
end
puts 'signature: '
puts ' r: %#x' % signature.r
puts ' s: %#x' % signature.s

signature_der_string = ECDSA::Format::SignatureDerString.encode(signature)
signature = ECDSA::Format::SignatureDerString.decode(signature_der_string)
valid = ECDSA.valid_signature?(public_key, digest, signature)
puts "valid: #{valid}"
