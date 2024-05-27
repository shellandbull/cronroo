module CronRoo
  VALUE_TYPES = [
    {
      value:  :any,
      symbol: /^\*$/,
    },
    {
      value:  :separator,
      symbol: /^,$/
    },
    {
      value:  :range,
      symbol: /^-$/,
    },
    {
      value:  :step_range,
      symbol: /^\/$/,
    },
    {
      value: :number,
      symbol: /[0-9]/
    }
  ]
end
