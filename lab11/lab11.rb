require 'digest'

puts 'MD5'
puts Digest::MD5.hexdigest 'Astrouskaya'
puts Digest::MD5.hexdigest 'Astrouskaya'
puts Digest::MD5.hexdigest 'astrouskaya'
puts 'SHA'
puts Digest::SHA1.hexdigest 'Astrouskaya'
puts Digest::SHA1.hexdigest 'Astrouskaya'
puts Digest::SHA1.hexdigest 'astrou'
