class UserModifier
  def initialize(app_name = "MyApp")
    @app_name = app_name
  end

  def secure
    puts "Securing users."

    user_model = IO.readlines("#{@app_name}/app/models/user.rb")
    attr_accessibles_pos = user_model.index { |line| line.index("attr_accessible") }
    user_model[attr_accessibles_pos].sub!(":password_digest", ":password, :password_confirmation")
    user_model.insert(attr_accessibles_pos + 1, "  has_secure_password")

    f = File.new("#{@app_name}/app/models/user.rb", 'w')
    user_model.each { |line| f.puts line }
    f.close
  end

  def repair_form
    puts "Repairing user form."

    user_form = IO.readlines("#{@app_name}/app/views/users/_form.html.erb")

    password_digest_pos = user_form.map(&:strip).index("<%= f.label :password_digest, :class => 'control-label' %>")
    user_form.slice!((password_digest_pos - 1)..(password_digest_pos + 4))

    email_pos = user_form.map(&:strip).index("<%= f.label :email, :class => 'control-label' %>")
    password_fields = [
      "  <div class=\"control-group\">",
      "    <%= f.label :password, :class => 'control-label' %>",
      "    <div class=\"controls\">",
      "      <%= f.password_field :password, :class => 'text_field' %>",
      "    </div>",
      "  </div>",
      "  <div class=\"control-group\">",
      "    <%= f.label :password_confirmation, :class => 'control-label' %>",
      "    <div class=\"controls\">",
      "      <%= f.password_field :password_confirmation, :class => 'text_field' %>",
      "    </div>",
      "  </div>"
      ]

    password_fields.reverse.each do |line|
      user_form.insert(7, line)
    end

    f = File.new("#{@app_name}/app/views/users/_form.html.erb", 'w')
    user_form.each { |line| f.puts line }
    f.close
  end

  def repair_show
    puts "Repairing user show."

    user_show = IO.readlines("#{@app_name}/app/views/users/show.html.erb")

    user_show_deletions = [
      "  <dt><strong><%= model_class.human_attribute_name(:password_digest) %>:</strong></dt>",
      "  <dd><%= @user.password_digest %></dd>"
      ]
    user_show_deletions.each do |deletion|
      user_show.delete(deletion + "\n")
    end

    f = File.new("#{@app_name}/app/views/users/show.html.erb", 'w')
    user_show.each { |line| f.puts line }
    f.close
  end

  def repair_index
    puts "Repairing user index."

    user_index = IO.readlines("#{@app_name}/app/views/users/index.html.erb")

    user_index.delete("      <th><%= model_class.human_attribute_name(:password_digest) %></th>\n")
    user_index.delete("        <td><%= user.password_digest %></td>\n")

    f = File.new("#{@app_name}/app/views/users/index.html.erb", 'w')
    user_index.each { |line| f.puts line }
    f.close
  end
  
  def make_root_url
    Dir.chdir("#{@app_name}") { `rm public/index.html` }
    
    routes = IO.readlines("#{@app_name}/config/routes.rb")
    
    routes.insert(2, "root :to => 'users#index'")
    
    f = File.new("#{@app_name}/config/routes.rb", 'w')
    routes.each { |line| f.puts line }
    f.close
  end
end