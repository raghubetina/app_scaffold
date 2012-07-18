class GemfileModifier
  def initialize(app_name = "MyApp")
    @app_name = app_name
  end
  
  def modify
    puts "Modifying Gemfile."

    gemfile = IO.readlines("#{@app_name}/Gemfile")

    gemfile_deletions = [
      "gem 'sqlite3'"
      ]

    gemfile_insertions = [
      "gem 'twitter-bootstrap-rails', '2.1.0'",
      "",
      "group :development do",
      "  gem 'sqlite3'",
      "end",
      "",
      "group :production do",
      "  gem 'pg'",
      "end",
      "",
      "gem 'bcrypt-ruby', '~> 3.0.0'",
      ""
      ]
  
    gemfile_deletions.each do |deletion|
      gemfile.delete(deletion + "\n")
    end

    gemfile_insertions.reverse.each do |insertion|
      gemfile.insert(2, insertion)
    end

    f = File.new("#{@app_name}/Gemfile", 'w')
    gemfile.each { |line| f.puts line }
    f.close
  end

  def bundle
    puts "Installing gems."

    Dir.chdir("#{@app_name}") { `bundle install` }
  end
end