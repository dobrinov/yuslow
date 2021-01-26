require_relative 'yuslow/investigation'
require_relative 'yuslow/operation'
require_relative 'yuslow/stdout_printer'

module Yuslow
  extend self

  def run(debug: false, output: nil, max_depth: nil)
    raise 'Block expected' unless block_given?

    investigation = Investigation.new debug: debug, printer: printer_from(output), max_depth: max_depth
    investigation.start
    yield
    investigation.finish
    investigation
  end

  def investigation(debug: false, output: nil, max_depth: nil)
    Investigation.new debug: debug, printer: printer_from(output), max_depth: max_depth
  end

  private

  def printer_from(param)
    case param
    when false   then nil
    when :stdout then StdoutPrinter
    else
      StdoutPrinter
    end
  end
end
