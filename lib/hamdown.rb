require 'rubygems'
require 'rdiscount'
require 'haml'

class Hamdown
  def initialize(options={})
    file = options.delete(:file_path) { raise "you need to specify a file name" }
    @innerfile = RDiscount.new(File.open(file).read)
    @outerfile = File.open('layout.haml')
  end

  def to_html
    Haml::Engine.new(@outerfile.read).render { @innerfile.to_html }
  end

end
