require 'active_support/inflector'
require 'csv'

class AssociationBuilder
  def initialize(app_name = "MyApp")
    @app_name = app_name
  end
  
  def build_associations
    puts "Building associations."
    CSV.foreach("models.csv") do |row|
      model = row.shift
    
      row.compact.each do |column|
        parsed = column.split(':').first.split('_')
        ending = parsed.last
        if ending == "id"
          foreign_key = parsed.first
          puts "Foreign key #{foreign_key} detected in #{model}."
          
          puts "Adding belongs_to to #{model}."
          model_file = IO.readlines("#{@app_name}/app/models/#{model.downcase}.rb")
          model_file.insert(1, "  belongs_to :#{foreign_key}")
          
          f = File.new("#{@app_name}/app/models/#{model.downcase}.rb", 'w')
          model_file.each { |line| f.puts line }
          f.close
          
          #TODO: Clean this up a lot. All CSV parsing needs to be done with headers.
          descriptor = ""
          CSV.foreach("models.csv") do |test_model_row|
            test_model = test_model_row.shift.downcase
            if test_model == foreign_key
              descriptor = test_model_row.first.split(':').first
            end
          end
          
          puts "Using #{descriptor} as descriptor for #{foreign_key.capitalize}."
          
          puts "Fixing #{model} show template."
          
          #TODO: Reading and/or writing need to be refactored into method.
          model_show = IO.readlines("#{@app_name}/app/views/#{model.pluralize.downcase}/show.html.erb")
          foreign_key_label_pos = model_show.map(&:strip).index("<dd><%= @#{model.downcase}.#{foreign_key}_id %></dd>")
          model_show[foreign_key_label_pos] = "  <dd><%= @#{model.downcase}.#{foreign_key}.#{descriptor} %></dd>"
          f = File.new("#{@app_name}/app/views/#{model.pluralize.downcase}/show.html.erb", 'w')
          model_show.each { |line| f.puts line }
          f.close
          
          puts "Fixing #{model} index template."

          model_index = IO.readlines("#{@app_name}/app/views/#{model.pluralize.downcase}/index.html.erb")
          foreign_key_td_pos = model_index.map(&:strip).index("<td><%= #{model.downcase}.#{foreign_key}_id %></td>")
          model_index[foreign_key_td_pos] = "        <td><%= #{model.downcase}.#{foreign_key}.#{descriptor} %></td>"
          f = File.new("#{@app_name}/app/views/#{model.pluralize.downcase}/index.html.erb", 'w')
          model_index.each { |line| f.puts line }
          f.close
          
          puts "Fixing #{model} form."

          model_form = IO.readlines("#{@app_name}/app/views/#{model.pluralize.downcase}/_form.html.erb")
          foreign_key_field_pos = model_form.map(&:strip).index("<%= f.number_field :#{foreign_key}_id, :class => 'number_field' %>")
          model_form[foreign_key_field_pos] = "      <%= f.collection_select :#{foreign_key}_id, #{foreign_key.capitalize}.all, :id, :#{descriptor} %>"
          f = File.new("#{@app_name}/app/views/#{model.pluralize.downcase}/_form.html.erb", 'w')
          model_form.each { |line| f.puts line }
          f.close
          
          puts "Adding has_many to #{foreign_key.capitalize}."
          model_file = IO.readlines("#{@app_name}/app/models/#{foreign_key}.rb")
          model_file.insert(1, "  has_many :#{model.pluralize.downcase}")
          
          f = File.new("#{@app_name}/app/models/#{foreign_key}.rb", 'w')
          model_file.each { |line| f.puts line }
          f.close
        end
      end
    end
  end
end