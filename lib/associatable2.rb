require_relative 'associatable'

module Associatable

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      source = source_name.to_s
      from_table = through_name.to_s.capitalize.constantize.table_name
      source_table = source.tableize
       data = DBConnection.execute(<<-SQL, self.owner_id)
       SELECT
          #{source_table}.*
        FROM
          #{from_table}
        JOIN
          #{source_table} ON #{from_table}.#{source}_id = #{source_table}.id
        WHERE
          #{from_table}.id = ?
        SQL

        House.new(data.first)
    end
  end
end
