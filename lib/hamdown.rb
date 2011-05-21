require 'rubygems'
require 'rdiscount'
require 'haml'

class Hamdown
  def initialize(options={})
    file = options.delete(:file_path) { raise "you need to specify a file name" }
    @innerfile = File.open(file).read
    @outerfile = File.open('layout.haml')
  end

  def to_html(options={})
    columns = options.delete(:columns) { false }
    if columns
      first_half = ""
      second_half = ""
      line_count = (@innerfile.lines.count / 2.0).ceil
      blank_line = ""
      @innerfile.each_with_index do |line, index|
        if index < line_count
          first_half << line
          blank_line = line.match(/^\s*$/) if index = line_count - 1
        elsif index == line_count && !blank_line
          first_half << line
        else
          second_half << line
        end
      end
      html = "<table><tr><td>\n"
      html << RDiscount.new(first_half).to_html
      html << "</td>\n<td>\n"
      html << RDiscount.new(second_half).to_html
      html << "</td></tr></table>"
    else
      html = RDiscount.new(@innerfile).to_html
    end
    Haml::Engine.new(@outerfile.read).render { html }
  end

end