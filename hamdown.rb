require 'rubygems'
require 'rdiscount'
require 'haml'

innerfile = RDiscount.new(File.open(ARGV[0]).read)
outerfile = File.open('layout.haml')
puts Haml::Engine.new(outerfile.read).render { innerfile.to_html }
