require 'rubygems'
require 'rdiscount'
require 'haml'

class Hamdown
  def initialize(options={})
    file = options.delete(:file_path) { raise "you need to specify a file name" }
    @innerfile = File.open(file).read
    @outerfile = File.open('layout.haml').read
  end

  def to_html(options={})
    columns = options.delete(:columns) { false }
    timestamp
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
    Haml::Engine.new(@outerfile).render { html }
  end

  def timestamp
    lines = ''
    @innerfile.each do |line|
      if line.match(/(\[:(.*):\])/)
        if $2 == 'today'
          line.gsub!($1, Time.now.strftime('%B %d, %Y'))
        elsif $2 == 'tomorrow'
          line.gsub!($1, (Time.now + (24*60*60)).strftime('%B %d, %Y'))
        end
      end
      lines << line + '\n'
    end
    @innerfile = lines
  end

end
