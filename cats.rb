require_relative "lib/01_sql_object"
require "pry"

class House < SQLObject
  self.finalize!
end

class Cat < SQLObject
  self.finalize!
end
