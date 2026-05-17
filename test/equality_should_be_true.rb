# #555 (gurgeous/Adam Doppelt). A corpus of `should be true`
# expressions that compiled to false in spinel pre-fix.
# Each line is an independent equality predicate; CRuby
# returns true for all twelve, and after this commit spinel
# matches on cases 1-6 and 8-10. Cases 7, 11, 12 remain as
# follow-up gaps (see commit message).

p ({} == {})                                     # 01
p ({a: 1} == {a: 1})                             # 02
p ({:a= => 1} == {:"a=" => 1})                   # 03
p ({:a! => 1} == {:"a!" => 1})                   # 04
p ({:a? => 1} == {:"a?" => 1})                   # 05
a = [1] ; a.shift ; a << :foo ; p (a == [:foo])  # 06
a2 = [1, 2, 3, 4, 5] ; p ((a2[2, 3] = 10) == 10) # 08
p ("hello".chars == ['h', 'e', 'l', 'l', 'o'])   # 09
p "abc\r\n".chomp(nil) == "abc\r\n"              # 10
