require 'active_support/inflector'
require './rails_column'
class RailsModel

  attr_reader :name
  attr_reader :has_many

  def add_has_many(model)
    @has_many << model.name.underscore.pluralize.to_sym
  end
  
  def belongs_to
    @belongs_to ||= @foreign_keys.map { |fk| fk.to_s.sub(/_id$/,'').to_sym }.sort
  end
  
  def initialize(name, columns)
    @name = name.strip.classify
    @columns = columns.compact.map { |c| RailsColumn.new(c) }
    @foreign_keys = @columns.select { |c| c.foreign_key? }.map { |c| c.name }.sort
    @has_many = []
  end
  
end
