# Float#ceil/floor/round/truncate with ndigits return type
# CRuby returns Integer when ndigits <= 0, Float when ndigits > 0.
# Previously Spinel always returned Float for any non-zero ndigits.

# ceil
puts 1.9.ceil.class
puts 1.9.ceil(0).class
puts 1.9.ceil(-1).class
puts 1.111.ceil(1).class

# floor
puts 1.9.floor.class
puts 1.9.floor(0).class
puts 1.9.floor(-1).class
puts 1.999.floor(1).class

# round
puts 1.5.round.class
puts 1.5.round(0).class
puts 1.5.round(-1).class
puts 1.234.round(2).class

# truncate
puts 1.9.truncate.class
puts 1.9.truncate(0).class
puts 1.9.truncate(-1).class
puts 1.999.truncate(1).class

# value checks for negative ndigits
puts 15.5.ceil(-1)
puts 1.999.floor(-1)
puts 15.5.round(-1)
puts 15.5.truncate(-1)
