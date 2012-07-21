require 'active_support/inflector'
require_relative 'rails_model'

class DomainModeler
  
  attr_reader :models
  
  def initialize(filename)
    @data = CSV.table(filename, headers: false)
    identify_models
    @models.each do |model|
      model.belongs_to.each do |bt|
        self[bt].add_has_many(model)
      end
    end
  end
  
  def each
    @models.each do |model|
      yield model
    end
  end
  
  def [](model_name)
    models.detect { |m| m.name.downcase == model_name.to_s.downcase.strip }
  end
  
  def model_names
    models.map { |m| m.name }.sort
  end
  
  def identify_models
    @models ||= @data.map { |row| RailsModel.new(row.shift, row) }
  end
  
  def identify_associations
    models.each do |model|
      
    end
  end
  
end

