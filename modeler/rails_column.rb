class RailsColumn

  attr_accessor :name
  attr_accessor :type

  def initialize(declaration)
    @name, @type = declaration.downcase.split(':')
    @type ||= (@name =~ /_id$/) ? 'integer' : 'string'
    @name = @name.to_sym
    @fk = @name =~ /_id$/
  end

  def foreign_key?
    @fk != nil
  end
  
  def to_s
    "#{@name}:#{@type}"
  end
  
end
