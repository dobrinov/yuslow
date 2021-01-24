class Dummy
  class << self
    def execute(delay: false)
      new(delay: delay).execute
    end
  end

  def initialize(delay: false)
    @delay = delay
  end

  def execute
    foo
    bar
  end

  def foo
    slow_operation_one
  end

  def bar
    slow_operation_two
    slow_operation_three
  end

  def slow_operation_one
    sleep 0.1 if @delay
  end

  def slow_operation_two
    sleep 0.2 if @delay
  end

  def slow_operation_three
    sleep 0.3 if @delay
  end
end
