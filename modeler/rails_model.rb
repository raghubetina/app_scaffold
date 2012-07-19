require 'active_support/inflector'
require './modeler/rails_column'
class RailsModel

  attr_reader :name
  attr_reader :has_many
  attr_reader :columns

  def add_has_many(model)
    @has_many << model.name.underscore.pluralize.to_sym
  end
  
  def belongs_to
    @belongs_to ||= @foreign_keys.map { |fk| fk.to_s.sub(/_id$/,'').to_sym }.sort
  end
  
  def class_path(app_root)
    @class_path ||= File.join(app_root, "app", "models", "#{name.underscore}.rb")
  end
  
  def index_path(app_root)
    @index_path ||= File.join(app_root, "app", "views", name.pluralize.underscore, "index.html.erb")
  end
  
  def show_path(app_root)
    @show_path ||= File.join(app_root, "app", "views", name.pluralize.underscore, "show.html.erb")
  end
  
  def initialize(name, columns)
    @name = name.strip.classify
    @columns = columns.compact.map { |c| RailsColumn.new(c) }
    @foreign_keys = @columns.select { |c| c.foreign_key? }.map { |c| c.name }.sort
    @has_many = []
  end
  
end
