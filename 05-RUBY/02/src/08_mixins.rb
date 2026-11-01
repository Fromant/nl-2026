module Printable
  def print_info
    puts info
  end
end

class Report
  include Printable

  def info
    "Report: Ruby"
  end
end

Report.new.print_info
