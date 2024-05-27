module CronRoo
  EXPRESSION_UNITS = [
    {
      unit: :minute,
      allowed_values: (0..59),
    },
    {
      unit: :hour,
      allowed_values: (0..23),
    },
    {
      unit: :day_of_the_month,
      allowed_values: (1..31),
    },
    {
      unit: :month,
      allowed_values: (1..12),
    },
    {
      unit: :day_of_the_year,
      allowed_values: (1..7)
    }
  ]
end
