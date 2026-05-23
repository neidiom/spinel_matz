class Actor
  attr_reader :id

  def initialize(id)
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
end

scopes = []
i = 0
while i < 2000
  scopes << Scope.new(Actor.new("alice" + i.to_s), Context.new)
  i = i + 1
end

junk = []
i = 0
while i < 5000
  junk << Context.new
  i = i + 1
end

puts scopes[1999].actor.id
