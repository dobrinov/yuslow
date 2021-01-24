require_relative 'yuslow/investigation'
require_relative 'yuslow/operation'
require_relative 'yuslow/stdout_printer'

module Yuslow
  extend self

  def run(debug: false, output: nil)
    raise 'Block expected' unless block_given?

    investigation = Investigation.new debug: debug, printer: printer_from(output)
    investigation.start
    yield
    investigation.finish
    investigation
  end

  def investigation(debug: false, output: nil)
    Investigation.new debug: debug, printer: printer_from(output)
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
