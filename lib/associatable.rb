require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @name.constantize
  end

  def table_name
    # ...
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    opts = { foreign_key: "#{name}_id".to_sym, class_name: name.to_s.camelcase, primary_key: :id }
    opts.merge!(options)
    @name = name
    @foreign_key = opts[:foreign_key]
    @class_name = opts[:class_name]
    @primary_key = opts[:primary_key]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    opts = { foreign_key: "#{self_class_name}_id".downcase.to_sym, class_name: name.to_s.singularize.camelcase, primary_key: :id }
    opts.merge!(options)
    @name = name
    @foreign_key = opts[:foreign_key]
    @class_name = opts[:class_name]
    @primary_key = opts[:primary_key]
  end
end

module Associatable
  # debugger
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    define_method(options.name) do
      options.name.capitalize.constantize.where({
        options.primary_key => self.send()
      })
    end


  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  #
end
