class Actor
  attr_reader :present, :id

  def initialize(present, id)
    @present = present
    @id = id
  end
end

class Context
end

class Scope
  attr_reader :actor, :context

  def initialize(actor, context)
    @actor = actor
    @context = context
  end

  def self.for_actor(actor)
    Scope.new(actor, Context.new)
  end
end

i = 0
while i < 2000
  Scope.for_actor(Actor.new(1, "alice"))
  i = i + 1
end

puts "ok"
