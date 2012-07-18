require 'active_support/inflector'
require 'csv'

class BootstrapInstaller
  def initialize(app_name = "MyApp", layout_name = "fixed")
    @app_name = app_name
    @layout_name = layout_name
  end

  def install
    puts "Installing bootstrap."

    Dir.chdir("#{@app_name}") { `rails g bootstrap:install` }
  end

  def generate_layout
    puts "Generating layout."

    Dir.chdir("#{@app_name}") { `rails g bootstrap:layout application #{@layout_name} -f` }
  end

  def theme_scaffolds
    CSV.foreach("models.csv") do |row|
      model = row.first
      puts "Theming #{model.pluralize}."
      Dir.chdir("#{@app_name}") { `rails g bootstrap:themed #{model.pluralize} -f` }
    end
  end
end