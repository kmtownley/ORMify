require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    if @columns
      return @columns
    else
    columns = DBConnection.execute2(<<-SQL).first
      SELECT
        *
      FROM
        #{self.table_name}
      LIMIT
        0
      SQL
    end
    columns.map!(&:to_sym)
    @columns = columns
  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column) do
        self.attributes[column]
      end

      define_method("#{column}=") do |col_value|
        self.attributes[column] = col_value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    if @tabe_name
      return @table_name
    else
      @table_name = self.name.underscore + "s"
    end
  end

  def self.all
    data = DBConnection.execute(<<-SQL)
     SELECT
       #{table_name}.*
     FROM
       #{table_name}
       SQL
    parse_all(data)
  end

  def self.parse_all(results)
    results.map {|result| self.new(result) }
  end

  def self.find(id)
    data = DBConnection.execute(<<-SQL, id)
      SELECT
       #{table_name}.*
      FROM
       #{table_name}
      WHERE
        #{table_name}.id = ?
      SQL

    parse_all(data).first
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name_sym = attr_name.to_sym
      if !self.class.columns.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name_sym}'"
      else
        self.send("#{attr_name_sym}=", value)
      end
    end
  end

  def attributes
    @attributes || @attributes = {}
  end

  def attribute_values
    self.class.columns.map {|attr| self.send(attr)}
  end

  def insert
    cols = self.class.columns.drop(1)
    col_names = cols.map(&:to_s).join(",")
    q_marks =  (["?"] * cols.count).join(",")
    attr_vals = self.attribute_values
    DBConnection.execute(<<-SQL, *attr_vals.drop(1))
      INSERT INTO
      #{self.class.table_name} (#{col_names})
      VALUES
      (#{q_marks})
      SQL
    self.id = DBConnection.last_insert_row_id
  end

  def update
    set_line = self.class.columns.map{|attr_name| "#{attr_name}= ?"}.join(",")
    attr_vals = self.attributes.values
    DBConnection.execute(<<-SQL, *attr_vals, id)
      UPDATE
        #{self.class.table_name}
      SET
        #{set_line}
      WHERE
        #{self.class.table_name}.id = ?
      SQL
  end

  def save
    if id.nil?
      insert
    else
      update
    end
  end
end
