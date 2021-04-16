# grade = 'C'

# case grade
#   in 'A' then puts 'Amazing effort'
#   in 'B' then puts 'Good work'
#   in 'C' then puts 'Well done'
#   in 'D' then puts 'Room for improvement'
#   else puts 'See me'
# end

# arr = [1, 2, 3, 4, 5]

# case arr
# in [1, 2, 3, a, b]
#   puts a
#   puts b
# end

# case [1, 2, 3, [4, 5]]
# in [1, 2, 3, [4, a] => arr]
#   puts a
#   p arr
# end

# case { a: 'apple', b: 'banana' }
# in { a: 'aardvark', b: 'bat' }
#   puts :no_match
# in { a: 'apple', b: 'banana' }
#   puts :match
# end

# case { a: 'apple', b: 'banana' }
# in { a: a, b: b }
#   puts a
#   puts b
# end

case { a: 'ant', b: 'ball', c: 'cat' }
in { a: 'ant', **rest }
  p rest
end
