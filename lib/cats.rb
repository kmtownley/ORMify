require_relative "lib/01_sql_object"
require "pry"
# split into three, house inside library

class House < SQLObject
  self.finalize!
end

class Cat < SQLObject
  self.finalize!
end

class Human < SQLObject
  self.table_name = "humans"
  self.finalize
end
