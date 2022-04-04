module Func5

  # @param [text] message
  # @param [number_of_cols] key    #n
  def self.encrypt_skitala(message, key)
    len = message.length
    rows = (len.to_f / key).ceil
    m = Matrix.build(rows, key) { message.slice!(0, 1) }
    puts m
    result = ''
    m.transpose.each do |symbol|
      result += symbol
    end
    result
  end
  def self.decrypt_skitala(message, key)
    len = message.length
    rows = (len.to_f / key).ceil
    m = Matrix.build(key, rows) { message.slice!(0, 1) }
    # puts m
    result = ''
    m.transpose.each do |symbol|
      result += symbol
    end
    result
  end

  def self.encrypt_change(message, name, surname)
    m = Matrix.build(surname.length, name.length) { message.slice!(0, 1) }
    m = m.transpose
    puts m
    rows = []
    (0...name.length).each { |index| rows << m.row(name.index(index).to_i).to_a }
    puts result_temp = Matrix.rows(rows)
    result_temp = result_temp.transpose
    cols = []
    (0...surname.length).each { |index| cols << result_temp.row(surname.index(index).to_i).to_a }
    puts result = Matrix.rows(cols)
    give_string(result)
  end

  def self.decrypt_change(message, name, surname)
    m = Matrix.build(surname.length, name.length) { message.slice!(0, 1) }
    puts m
    cols = []
    surname.each { |index| cols << m.row(index).to_a }
    puts result_temp = Matrix.rows(cols)
    result_temp = result_temp.transpose
    rows = []
    name.each { |index| rows << result_temp.row(index).to_a }
    puts result = Matrix.rows(rows)
    result = result.transpose
    give_string(result)
  end

  def self.give_string(result)
    text = ''
    result.each do |symbol|
      text += symbol
    end
    text
  end

  def self.order_of_letters(text)
    sorted = text.chars.sort.join
    result = []
    text.split('').each do |symbol|
      result << sorted.index(symbol).to_i
    end
    result
  end
end