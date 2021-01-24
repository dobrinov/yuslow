class Operation
  attr_reader :parent, :children

  class << self
    def start(object, method)
      new(object, method)
    end
  end

  def initialize(object:, method:, parent: nil, started_at: Time.now, completed_at: nil, children: [])
    @object = object
    @method = method
    @started_at = started_at
    @completed_at = completed_at
    @parent = parent
    @children = children
  end

  def fork(object:, method:)
    operation = self.class.new object: object, method: method, parent: self
    @children << operation

    operation
  end

  def identifier
    "#{@object}##{@method}"
  end

  def complete
    raise 'This operation is already completed' if @completed_at

    @completed_at = Time.now
  end

  def elapsed
    ((@completed_at - @started_at) * 1000).round if @completed_at
  end
end
