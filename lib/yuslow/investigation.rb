module Yuslow
  class Investigation
    def initialize(debug: false, printer: nil, max_depth:)
      if max_depth
        raise ArgumentError, 'max_depth must be a number'      if !max_depth.is_a? Numeric
        raise ArgumentError, 'max_depth cannot be less than 1' if max_depth < 1
      end

      @printer = printer
      @debug = debug
      @tracing = false
      @trace = nil
      @max_depth = max_depth
      @execution = {}
    end

    def start
      @trace = TracePoint.new(:call, :return, :c_call, :c_return) do |trace_point|
        thread_id = Thread.current.object_id
        @execution[thread_id] ||= {root: nil, current: nil, depth: 0}

        if trace_point.defined_class == self.class
          if trace_point.callee_id == :start
            @tracing = true
          elsif trace_point.callee_id == :finish
            @tracing = false
          else
            raise "Unexpected method #{trace_point.callee_id} called on #{self.class}"
          end
        elsif @tracing
          if %i(call c_call).include?(trace_point.event)
            if !@max_depth || @execution[thread_id][:depth] < @max_depth
              if @execution[thread_id][:current]
                @execution[thread_id][:current] = @execution[thread_id][:current].fork object: trace_point.defined_class,
                                                                                       method: trace_point.callee_id
              else
                operation = Operation.new object: trace_point.defined_class, method: trace_point.callee_id
                @execution[thread_id][:root]    = operation
                @execution[thread_id][:current] = operation
              end

              debug trace_point, @execution[thread_id][:depth]
              @execution[thread_id][:depth] += 1
            end
          elsif %i(return c_return).include? trace_point.event
            if @execution[thread_id][:current]&.identifier == "#{trace_point.defined_class}##{trace_point.callee_id}"
              @execution[thread_id][:depth] -= 1

              if !@max_depth || @execution[thread_id][:depth] < @max_depth
                debug trace_point, @execution[thread_id][:depth]

                @execution[thread_id][:current]&.complete
                @execution[thread_id][:current] = @execution[thread_id][:current]&.parent
              end
            end
          end
        end
      end

      @trace.enable
    end

    def finish
      @trace.disable

      print_result @printer if @printer
    end

    def debug(trace_point, indent)
      return unless @debug

      puts (' ' * indent) + "#{trace_point.event} #{trace_point.defined_class}##{trace_point.callee_id}"
    end

    def print_result(printer)
      return unless printer

      operations =
        @execution.keys.map do |thread_id|
          @execution[thread_id][:root]
        end.compact

      printer.execute operations
    end
  end
end
