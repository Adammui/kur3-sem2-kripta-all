module Func4

  @german = ' abcdefghijklmnopqrstuvwxyzäöüß'
  @alpha = ' абвгдеёжзійклмнопрстуўфхцчшыьэюя'
  @alpha_length = @alpha.length
  def self.alpha_sdvig(key)
    alpha_k = @alpha
    (1..key).each do |i|
      alpha_k = alpha_k[1..-1] + alpha_k[0, 1]
    end
    alpha_k
  end

  def self.encrypt_sdvigom(message, key)
    encrypted = ''
    puts encrypted_alpha = alpha_sdvig(key)
    message.split('').each do |symbol|
      position_new = @alpha.index(symbol).to_i + key.modulo(@alpha_length)
      encrypted += @alpha[position_new]
    rescue StandardError
      next
    end
    encrypted
  end

  def self.decrypt_sdvigom(message, key)
    decrypted = ''
    puts @alpha
    message.split('').each do |symbol|
      position_new = @alpha.index(symbol) - key.modulo(@alpha_length)
      decrypted += @alpha[position_new]
    end
    decrypted
  end

  def self.encrypt_vijiner(key_str, text_srt)
    key_arr = str_to_alphabet_index_arr(key_str)
    char_number_at_text = 0
    str_to_alphabet_index_arr(text_srt).inject("") do |r, letter_index|
      encode_letter_index = (letter_index + key_arr[char_number_at_text % key_arr.size]) % @alpha.size
      char_number_at_text += 1
      r + @alpha[encode_letter_index]
    end
  end

  def self.decrypt_vijiner(key_str, text_srt)
    key_arr = str_to_alphabet_index_arr(key_str)
    char_number_at_text = 0
    str_to_alphabet_index_arr(text_srt).inject("") do |r, letter_index|
      decode_letter_index = (letter_index + @alpha.size - key_arr[char_number_at_text % key_arr.size]) % @alpha.size
      char_number_at_text += 1
      r + @alpha[decode_letter_index]
    end
  end

  def self.str_to_alphabet_index_arr(str)
    str.chars.map do |char|
      index = @alpha.index(char)
      index || raise(CryptoError, 'letters should be at alphabet')
    end
  end
end
class CryptoError < StandardError ; self; end