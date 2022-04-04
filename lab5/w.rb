def self.encrypt_change(table, name, surname)
  sub_table = []
  crypt_table = []
  (0..(name.length - 1)).each do |str|
    sub_table << table[name[str] - 1]
  end
  sub_table = sub_table.transpose
  (0..(surname.length - 1)).each do |col|
    crypt_table << sub_table[surname[col] - 1]
  end
  crypt_table.transpose
end

def self.decrypt_change(crypt_table, name, surname)
  crypt_table = crypt_table.transpose
  sub_table = []
  decrypt_table = []
  (0..(surname.length - 1)).each do |col|
    sub_table << crypt_table[surname[col] - 1]
  end
  sub_table = sub_table.transpose
  (0..(name.length - 1)).each do |str|
    decrypt_table << sub_table[name[str] - 1]
  end
  decrypt_table
end

def self.text_to_table(text, name, surname)
  table = []
  textarr = text.split('')
  i = 0
  (0..(name.length - 1)).each do |str|
    subarr = []
    (0..(surname.length - 1)).each do |col|
      subarr << textarr[i]
      i += 1
    end
    table << subarr
  end
  table
end

def self.table_to_s(table, name, surname)
  txt = ""
  (0..(name.length - 1)).each do |str|
    (0..(surname.length - 1)).each do |col|
      txt << table[str][col].to_s
    end
  end
  txt
end
