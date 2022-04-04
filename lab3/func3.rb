require 'prime'

module Func3

  def self.nod(a, b, c = 0)
    if c < a && c < b
      nod = raw_nod(a, b)
      #(c % nod).zero? ? a : 1
      nod = raw_nod(c, nod)
    elsif b < a && b < c
      nod = raw_nod(a, c)
      nod = raw_nod(b, nod)
    else
      nod = raw_nod(b, c)
      nod = raw_nod(a, nod)
    end
    nod
  end

  def self.raw_nod(a, b)
    until b.eql? 0
      a, b = b, a % b
    end
    a
  end

  def self.find_prime(n, m)
    return false if n < 2

    counter = 0
    (n...m).each do |num|
      if prime?(num)
        puts num
        counter += 1
      end
    end
    "Колво простых чисел: #{counter}"
  end

  def self.prime?(number)
    return false if number < 2

    (2..number - 1).each do |n|
      return false if (number % n).zero?
    end
    true
  end
end