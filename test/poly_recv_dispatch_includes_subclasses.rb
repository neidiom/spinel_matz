# Polymorphic-receiver dispatch must include subclass arms when the
# ivar's observed types narrow to a base class but the runtime value
# may be a subclass instance written via a typed setter. Without this
# the dispatch loop only emits the base-class arm and a subclass
# override is silently skipped — the #616 filter-elision shape (tep's
# `app.@before_filter.before(req, res)` where the override never
# fires because @before_filter is declared `Tep::Filter` but the
# stored runtime value is `TepFilters_before`).

class Pipeline
  attr_accessor :step
  def initialize; @step = Step.new; end
  def set_step(s); @step = s; end
  def run(out)
    @step.process(out)
  end
end

class Step
  def process(out)
    out[:base] = "ran"
  end
end

class UpcaseStep < Step
  def process(out)
    out[:sub] = "UPPER"
  end
end

p = Pipeline.new
p.set_step(UpcaseStep.new)
result = { base: "" , sub: "" }
p.run(result)
puts result[:base]   # "" (base override not invoked)
puts result[:sub]    # "UPPER" (subclass override invoked)
