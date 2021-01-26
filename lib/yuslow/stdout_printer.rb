module Yuslow
  module StdoutPrinter
    extend self

    def execute(operations, colorize = true)
      output = []

      operations.each_with_index.map do |operation, index|
        output << "Thread[#{index + 1}]:"
        output << stringify_operation(operation, 1, colorize)
        output << nil
      end

      print output.join "\n"
    end

    def stringify_operation(operation, indent, colorize)
      output = []
      indentation = '  ' * indent

      if operation.elapsed
        identifier = operation.identifier
        identifier = colorize(identifier, :green) if colorize

        elapsed = operation.elapsed
        elapsed = colorize(elapsed, :white) if colorize

        output << "#{indentation}#{identifier} elapsed #{elapsed} ms"
      else
        text = "#{operation.identifier} did not finish"
        colorize(text, :yellow) if colorize

        output << "#{indentation}#{text}"
      end

      operation.children.each do |child_operation|
        output << stringify_operation(child_operation, indent + 1, colorize)
      end

      output.join "\n"
    end

    def colorize(text, color)
      code =
        case color
        when :black    then '30'
        when :red      then '31'
        when :green    then '32'
        when :yellow   then '33'
        when :white    then '1;37'
        when :bg_black then '40'
        when :bg_red   then '41'
        when :bg_green then '42'
        else
          0
        end

      "\e[#{code}m#{text}\e[0m"
    end
  end
end
