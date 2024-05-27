require "active_support"
require "active_model"
require "terminal-table"
require "rainbow"

Dir["lib/**/**.rb"].each do |filename|
  require_relative filename
end
