require "./env"
require "pry"

parser = CronRoo::Parser.new(input: ARGV[0])

if parser.validate
  parser.expressions
  crons, command = parser.expressions.first(5).map { |exp| { unit: Rainbow(exp.unit[:unit]).green, value: Rainbow(exp.value.join(", ")).yellow } }, { unit: Rainbow("command").green, value: Rainbow(parser.expressions.last.input).yellow }
  table = Terminal::Table.new(rows: [crons, command].flatten.map(&:values))

  puts(table)
else
  puts Rainbow("Unable to parse string #{ARGV[0]}").red
  parser.errors.each do |error|
    puts Rainbow("- [:#{error.attribute}] => #{error.message}").red
  end
end
