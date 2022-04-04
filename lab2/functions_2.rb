module Functions_2

  def self.read_txt_file_to_string(file_path)
    ru = File.open(file_path)
    ru.read
  end
  def self.clean_text(message)
    message.delete('-').delete('—').delete('?').delete(':').delete('…')
           .delete('.').delete(',').delete("\n").downcase
  end
  def self.letters_count(message)
    txt_arr = clean_text(message).delete(' ').split('')

    hash = Hash.new
    txt_arr.each do |c|
      if hash.has_key?(c)
        hash[c] += 1
      else
        hash[c] = 1
      end
    end
    hash
  end

  def self.shannon_entropy(message)
    result = 0.00
    len = message.length
    hash = letters_count(message)

    hash.each do |key, value|
      frequency = value.to_f / len
      result -= frequency * Math.log(frequency, 2)
    end
    result
  end

  def self.information_amount(message)
    shannon_entropy(message).to_f * message.length
  end

  def self.information_amount_ascii(message)
    message.length * 8
  end

  def self.information_amount_w_mistake(message, error)
    shannon_entropy(message) - (-(1 - error)) * Math.log((1 - error), 2) - error * Math.log(error, 2) * message.length
  end
end
