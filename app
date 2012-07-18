require './gemfile_modifier.rb'
require './model_generator.rb'
require './bootstrap_installer.rb'
require './user_modifier.rb'
require './layout_modifier.rb'
require './association_builder.rb'

app_name = ARGV[0] || "MyApp"
layout_name = ARGV[1] || "fixed"

puts "Creating #{app_name} app."
`rails new #{app_name}`

g = GemfileModifier.new(app_name)
g.modify
g.bundle

m = ModelGenerator.new(app_name)
m.generate
m.migrate

b = BootstrapInstaller.new(app_name, layout_name)
b.install
b.generate_layout
b.theme_scaffolds

u = UserModifier.new(app_name)
u.secure
u.repair_form
u.repair_show
u.repair_index
u.make_root_url

l = LayoutModifier.new(app_name)
l.remove_sidebar
l.expand_main_div
l.fix_nav_bar_links
l.fix_misc

a = AssociationBuilder.new(app_name)
a.build_associations

Dir.chdir(app_name) { `rails s` }