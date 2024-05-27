module CronRoo
  class Command
    include ActiveModel::Model
    include ActiveModel::Validations
    attr_accessor :input
    validates_presence_of :input
  end
end
