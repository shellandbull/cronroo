module CronRoo
  class Parser
    MIN_EXPRESSION_LENGTH = 6
    include ActiveModel::Model
    include ActiveModel::Validations
    attr_accessor :input

    validates_presence_of :input
    validate :expressions_are_valid

    def errors
      @errors ||= ActiveModel::Errors.new(self)
    end

    def expressions
      @expressions ||= begin
        crons   = segments.slice(0, 5).zip(CronRoo::EXPRESSION_UNITS)
        command = segments.slice(5, segments.length).join(" ")

        [
          crons.map { |cr, exp| CronRoo::Expression.new(input: cr, unit: exp) },
          CronRoo::Command.new(input: command)
        ].flatten
      end
    end

    private

    def expressions_are_valid
      return errors.add(:base, "No expression provided") if input.nil?
      return errors.add(:input, "The input must have at least 6 segments") if invalid_segment_length?
      return errors.add(:input, "The input is not a valid crontab string") if invalid_crontab_string?
      expressions.each do |expression|
        next if expression.validate
        errors.add(:base, expression.errors.full_messages.join(" "))
      end
    end

    def invalid_crontab_string?
      !input.match(CronRoo::CRONTAB_STRING_REGEXP)
    end

    def invalid_segment_length?
      MIN_EXPRESSION_LENGTH > segments.length
    end

    def segments
      @segments ||= input.split
    end
  end
end
