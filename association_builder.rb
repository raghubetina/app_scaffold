require 'active_support/inflector'
require './modeler/domain_modeler'
require 'csv'

class AssociationBuilder
  def initialize(app_name = "MyApp")
    @app_name = app_name
  end

  def models
    @models ||= DomainModeler.new('models.csv')
  end
  
  def debug_mode?
    ARGV.empty?
  end
  
  def modify_file(path)
    puts "Modifying: #{path}" if debug_mode?
    
    lines = IO.readlines(path)
    yield lines
    IO.write(path, lines.compact.join("\n"))
    
    puts lines if debug_mode?
  end
  
  def association_lines(model, relationship)
    associations = []
    symbols = model.send(relationship)
    if symbols.any?
      symbols.each do |symbol|
        associations << "  #{relationship} :#{symbol}"
      end
    end
    return associations
  end  
  
  def build_associations
    puts "Building associations."

    models.each do |model|
      modify_file model.class_path(@app_name) do |model_file|
        [:belongs_to, :has_many].each do |assoc|
          model_file.insert(-2, association_lines(model, assoc)).flatten
        end
      end
    end
  end
  
  def search_and_destroy(lines, target, replacement)
    pos = lines.index { |line| line.index(target) }
    lines[pos].sub!(target, replacement) if pos
  end
  
  def fix_index
    puts "Fixing associated index templates."
    
    models.each do |model|
      modify_file model.index_path(@app_name) do |model_index|
        model.belongs_to.each do |bt|
          descriptor = models[bt].columns.first.name
          
          target = "#{model.name.downcase}.#{bt}_id"
          replacement = "link_to(#{model.name.downcase}.#{bt}.#{descriptor}, #{model.name.downcase}.#{bt}) if #{model.name.downcase}.#{bt}"
          search_and_destroy(model_index, target, replacement)
        end
      end
    end
  end
  
  def fix_show
    puts "Fixing associated show templates."
    
    models.each do |model|
      modify_file model.show_path(@app_name) do |model_show|
        model.belongs_to.each do |bt|
          descriptor = models[bt].columns.first.name
          
          target = "@#{model.name.downcase}.#{bt}_id"
          replacement = "link_to(@#{model.name.downcase}.#{bt}.#{descriptor}, @#{model.name.downcase}.#{bt}) if @#{model.name.downcase}.#{bt}"
          search_and_destroy(model_show, target, replacement)
        end
      end
    end
  end
  
  def fix_form
    puts "Fixing associated form templates."
    
    models.each do |model|
      modify_file model.form_path(@app_name) do |model_form|
        model.belongs_to.each do |bt|
          descriptor = models[bt].columns.first.name
          
          target = "<%= f.number_field :#{bt}_id, :class => 'number_field' %>"
          replacement = "<%= f.collection_select :#{bt}_id, #{bt.capitalize}.all, :id, :#{descriptor} %>"
          search_and_destroy(model_form, target, replacement)
        end
      end
    end
  end
end