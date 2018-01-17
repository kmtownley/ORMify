require_relative "lib/01_sql_object"
require "pry"
# split into three, house inside library

class Studio < SQLObject
  self.finalize!
end

class Yogi < SQLObject
  self.finalize!
end

class Teacher < SQLObject
  self.finalize!
end
