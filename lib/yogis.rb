require_relative "sql_object"
# split into three, house inside library


class Yogi < SQLObject
  self.finalize!
end
class Studio < SQLObject
  self.finalize!
end

class Teacher < SQLObject
  self.finalize!
end
