module Yuslow
  class Investigation
    def initialize(debug: false, printer: nil)
      @printer = printer
      @debug = debug
      @tracing = false
      @trace = nil
      @indent = 0
      @execution = {}
    end

    def start
      @trace = TracePoint.new(:call, :return, :c_call, :c_return) do |trace_point|
        thread_id = Thread.current.object_id
        @execution[thread_id] ||= {root: nil, current: nil}

        if trace_point.defined_class == self.class && trace_point.callee_id == :start
          @tracing = true
        elsif trace_point.defined_class == self.class && trace_point.callee_id == :finish
          @tracing = false
        elsif @tracing
          if %i(call c_call).include? trace_point.event
            if @execution[thread_id][:current]
              @execution[thread_id][:current] =
                @execution[thread_id][:current].fork object: trace_point.defined_class,
                                                     method: trace_point.callee_id
            else
              operation = Operation.new object: trace_point.defined_class, method: trace_point.callee_id
              @execution[thread_id][:root]    = operation
              @execution[thread_id][:current] = operation
            end

            debug trace_point, @indent
            @indent += 1

          elsif %i(return c_return).include? trace_point.event
            @indent -= 1
            debug trace_point, @indent

            @execution[thread_id][:current]&.complete
            @execution[thread_id][:current] = @execution[thread_id][:current]&.parent
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
        end

      printer.execute operations
    end
  end
end
