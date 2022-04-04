require './lab3/func3'
require_relative 'func3'
m = 450
n = 503
puts '1/ найти все простые числа в интервале [2, n]: '
puts Func3.find_prime(2, n)
puts '2/ найти все простые числа в интервале [m, n]: '
puts Func3.find_prime(m, n)
puts '3/ Нод m n и трех рандомных чисел'
puts Func3.nod(m, n)
puts Func3.nod(845, 65, 5)
puts '4/ разложение на простые делители m '
puts m.prime_division