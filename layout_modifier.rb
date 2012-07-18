require 'active_support/inflector'
require 'csv'

class LayoutModifier
  def initialize(app_name = "MyApp")
    @app_name = app_name
  end
  def remove_sidebar
    puts "Removing sidebar."

    application = IO.readlines("#{@app_name}/app/views/layouts/application.html.erb")

    sidebar_pos = application.map(&:strip).index("<div class=\"well sidebar-nav\">")
    application.slice!((sidebar_pos - 1)..(sidebar_pos + 9))

    f = File.new("#{@app_name}/app/views/layouts/application.html.erb", 'w')
    application.each { |line| f.puts line }
    f.close
  end

  def expand_main_div
    puts "Expanding main div."

    application = IO.readlines("#{@app_name}/app/views/layouts/application.html.erb")

    main_div_pos = application.map(&:strip).index("<div class=\"span9\">")
    application[main_div_pos] = "           <div class=\"span12\">"

    f = File.new("#{@app_name}/app/views/layouts/application.html.erb", 'w')
    application.each { |line| f.puts line }
    f.close
  end

  def fix_misc
    puts "Fixing miscellaneous."

    application = IO.readlines("#{@app_name}/app/views/layouts/application.html.erb")

    footer_pos = application.map(&:strip).index("<p>&copy; Company 2012</p>")
    application[footer_pos] = "        <p>&copy; #{@app_name} 2012</p>"

    brand_pos = application.map(&:strip).index("<a class=\"brand\" href=\"#\">#{@app_name.capitalize}</a>")
    application[brand_pos] = "          <a class=\"brand\" href=\"<%= root_url %>\">#{@app_name.capitalize}</a>"

    f = File.new("#{@app_name}/app/views/layouts/application.html.erb", 'w')
    application.each { |line| f.puts line }
    f.close
  end

  def fix_nav_bar_links
    puts "Fixing nav bar links."

    application = IO.readlines("#{@app_name}/app/views/layouts/application.html.erb")

    nav_bar_links_pos = application.map(&:strip).index("<li><%= link_to \"Link1\", \"/path1\"  %></li>")
    application.slice!(nav_bar_links_pos..(nav_bar_links_pos + 2))

    CSV.foreach("models.csv") do |row|
      model = row[0]
      application.insert(nav_bar_links_pos, "              <li><%= link_to \"#{model.pluralize.capitalize}\", \"/#{model.pluralize.downcase}\"  %></li>")
    end

    f = File.new("#{@app_name}/app/views/layouts/application.html.erb", 'w')
    application.each { |line| f.puts line }
    f.close
  end
end