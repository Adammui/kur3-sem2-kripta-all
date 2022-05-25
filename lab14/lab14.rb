require 'rmagick'
require 'chunky_png'

class LSB
  include ChunkyPNG

  def initialize(filename:)
    @filename = convert_to_png(filename)
    @img = Image.from_file(@filename)
  end

  def encode(message:, stego_filename:)
    message = message.force_encoding('UTF-8')
    unless message.ascii_only?
      puts 'Please only include ascii characters in the message.'
      return 1
    end

    binary_message = message.unpack1('B*').split(//).map(&:to_i)

    if img.area < binary_message.size
      puts "Message requires #{binary_message.size} pixels to encode and the "\
        "image contains only #{img.area} pixels."
      return 1
    end

    binary_message += [0] * (img.area - binary_message.size)

    img.height.times do |y|
      img.width.times do |x|
        img[x, y] = encode_pixel(img[x, y],
                                 binary_message[y * img.width + x])
      end
    end

    img.save(stego_filename)

    return 0
  end

  def decode
    message = []
    img.height.times do |y|
      img.width.times do |x|
        message << (Color.r(img[x, y]) % 2)
      end
    end

    message.each_slice(8).map { |s| s.map(&:to_s).join('') }
           .map { |s| [s].pack('B*') }.join('')
  end

  private

  attr_reader :img, :filename

  def convert_to_png(file)
    return file if file.split('.')[1] == 'png'

    img = Magick::Image.read(file)[0]
    img.format = 'png'
    png_name = "#{file.split('.')[0]}.png"
    img.write(png_name)
    png_name
  end

  def encode_pixel(pixel, bit)
    return pixel if ((Color.r(pixel) + bit) % 2).zero?

    Color.rgba(Color.r(pixel) + 1, Color.g(pixel),
               Color.b(pixel), Color.a(pixel))
  end
end
container = LSB.new(filename: '/home/rey/RubymineProjects/kripta/lab14/container.png')
result = container.encode(message: 'HELLO WORLD IM Darya'.dup,
                          stego_filename: '/home/rey/RubymineProjects/kripta/lab14/message.png')
if result.zero?
  puts 'Success!'
else
  puts 'Failed to encode.'
end
message = LSB.new(filename: '/home/rey/RubymineProjects/kripta/lab14/message.png')
puts message.decode

