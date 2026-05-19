# A local declared sp_StrPolyHash (because subsequent poly-value
# writes force the wider variant) initialized from
# `<str_str_hash>.dup` previously emitted bracket-assigns via
# sp_StrStrHash_set against the wider slot — hard cc type error.
# Half of #613: set_var_type now refuses to narrow a *_poly_hash
# slot back to its scalar-value sibling.

class Match
  attr_reader :path_params
  def initialize(pp); @path_params = pp; end
end

m = Match.new({ "article_id" => "1" })
merged = m.path_params.dup
merged["x"] = 1       # int value forces str_poly_hash analyzer-side widening
merged["y"] = "two"   # str value
puts merged.length    # 3
