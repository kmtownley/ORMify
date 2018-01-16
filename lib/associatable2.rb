require_relative 'associatable'

module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    debugger
    p through_options = self.assoc_options[through_name]
    p source_options= through_options.model_class.assoc_options[source_name]

    define_method(name) do
      debugger
      p source = source_name.to_s
      p from_table = through_name.to_s.capitalize.constantize.table_name
      p source_table = source.tableize
       data = DBConnection.execute(<<-SQL)
       SELECT
          #{source_table}.*
        FROM
          #{from_table}
        JOIN
          #{source_table} ON #{from_table}.#{source}_id = #{source_table}.id
        WHERE
          #{from_table}.id = ?
        SQL
    end
  end
end
