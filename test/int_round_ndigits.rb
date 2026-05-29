# Integer#round(ndigits): rounding to a given precision.
# Without ndigits, returns self. With negative ndigits,
# rounds to the nearest 10^(-ndigits).

p 1234.round        # no arg: self
p 1234.round(0)     # zero: self
p 1234.round(2)     # positive: self
p 1234.round(-1)    # round to tens: 1230
p 1234.round(-2)    # round to hundreds: 1200
p 1234.round(-3)    # round to thousands: 1000
p 1255.round(-2)    # half-up: 1300
p 1245.round(-2)    # half-down: 1200
p 99.round(-1)      # round to tens: 100
p 5.round(-1)       # round to tens: 10
