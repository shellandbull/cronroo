require_relative "./expression_units"
require_relative "./value_types"

module CronRoo
  class Expression
    include ActiveModel::Model
    include ActiveModel::Validations
    OPERATOR_TYPES = [:range, :step_range]
    EXPRESSION_REGEXP = /(\*|,|\/|-|\d+)/
    attr_accessor :input, :unit

    validates :unit, inclusion: { in: CronRoo::EXPRESSION_UNITS }

    def value
      parse_expression(expression: split_expression_string(input))
    end

    def parse_expression(expression:, parsed_value: [])
      return parsed_value if expression.empty?
      top = expression.shift
      nxt = expression.first

      if nxt.present? && operand_expression?(nxt)
        operand = expression.shift
        bottom  = expression.shift
        parsed_value.concat(parse_operand_subexpression(top:, operand:, bottom:))
      elsif operand_expression?(top)
        operand = top
        bottom  = expression.shift
        
        parsed_value = parse_composite_operand_subexpression(top: parsed_value, operand:, bottom:)
      elsif separator_expression?(nxt)
        expression.shift
        parsed_value.concat(parse_single_subexpression(top))
      elsif separator_expression?(top)
      else
        parsed_value.concat(parse_single_subexpression(top))
      end
      parse_expression(expression:, parsed_value:)
    end

    def parse_single_subexpression(subexp)
      value_type = find_value_type(subexp)

      case value_type[:value]
      when :any
        unit[:allowed_values].to_a
      when :number
        [subexp.to_i]
      end
    end

    def parse_operand_subexpression(top:, operand:, bottom:)
      parsed_top_subexp          = parse_single_subexpression(top)
      operand_subexp_value_type  = find_value_type(operand)
      parsed_bottom_subexp       = parse_single_subexpression(bottom)

      case operand_subexp_value_type.fetch(:value)
      when :separator
        parsed_top_subexp.concat(parsed_bottom_subexp)
      when :range
        (parsed_top_subexp.first..parsed_bottom_subexp.first).to_a
      when :step_range
        (parsed_top_subexp.first..parsed_top_subexp.last).step(parsed_bottom_subexp.first).to_a
      end
    end

    private

    def parse_composite_operand_subexpression(top:, operand:, bottom:)
      operand_subexp_value_type  = find_value_type(operand)
      parsed_bottom_subexp       = parse_expression(expression: split_expression_string(bottom))

      case operand_subexp_value_type.fetch(:value)
      when :separator
        top.concat(parsed_bottom_subexp).sort
      when :step_range
        (top.first..top.last).step(parsed_bottom_subexp.first).to_a
      end
    end

    def operand_expression?(subexp)
      OPERATOR_TYPES.include?(find_value_type(subexp).fetch(:value))
    end

    def separator_expression?(subexp)
      return false if subexp.nil?
      find_value_type(subexp).fetch(:value) == :separator
    end

    def find_value_type(subexp)
      val = value_types.find do |type|
        type[:symbol].match(subexp)
      end

      unless val
        raise NotImplementedError.new("Unable to find value type for #{subexp}")
      end

      val
    end

    def value_types
      CronRoo::VALUE_TYPES
    end

    def split_expression_string(string)
      string.scan(EXPRESSION_REGEXP).flatten
    end
  end
end
