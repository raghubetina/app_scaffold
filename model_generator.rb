require 'csv'

class ModelGenerator
  def initialize(app_name = "MyApp")
    @app_name = app_name
  end
  
  def generate
    CSV.foreach("models.csv") do |row|
      model = row.shift
      puts "Generating #{model} model."
      arguments = ""
      row.compact.each do |column|
        arguments << column + " "
      end
      command = model + " " + arguments
      Dir.chdir("#{@app_name}") { `rails g scaffold #{command}--no-stylesheets` }
    end
  end
  
  def migrate
    puts "Migrating database."
    Dir.chdir("#{@app_name}") { `rake db:migrate` }
  end
end