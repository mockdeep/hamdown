require 'rubygems'
require 'rdiscount'
require 'haml'

class Hamdown
  def initialize(options={})
    file = options.delete(:file_path) { raise "you need to specify a file name" }
    @innerfile = File.open(file).read
    @outerfile = File.exists?('layout.haml') ? File.open('layout.haml').read : nil
  end

  def to_html(options={})
    columns = options.delete(:columns) { false }
    tag = options.delete(:tag) { false }
    padlines = options.delete(:padlines) { 0 }
    @innerfile = insert_tags(@innerfile) if tag
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
      first_half = insert_padding(padlines, first_half)
      second_half = insert_padding(padlines, second_half)
      html = "<table><tr><td>\n"
      html << RDiscount.new(first_half).to_html
      html << "</td>\n<td>\n"
      html << RDiscount.new(second_half).to_html
      html << "</td></tr></table>"
    else
      @innerfile = insert_padding(padlines, @innerfile)
      html = RDiscount.new(@innerfile).to_html
    end
    @outerfile ? Haml::Engine.new(@outerfile).render { html } : html
  end

  def insert_tags(source_lines)
    lines = ''
    source_lines.each do |line|
      if line.match(/(\[:([a-zA-Z]+)(\+([1-9]+))?:\])/)
        case $2
        when 'dynamic'
          hours = $4 ? $4.to_i : 12
          time = Time.now.hour <= hours ? Time.now : Time.now + (24*60*60)
        when 'today'
          time = Time.now
        when 'tomorrow'
          time = Time.now + (24*60*60)
        end
        line.gsub!($1, time.strftime('%B %d, %Y'))
      end
      lines << line
    end
    lines
  end

  def insert_padding(padlines, source_lines)
    count = padlines - source_lines.lines.count
    source_lines += "_" * 10
    count.times { source_lines += "\n  \n  " + '\_' * 30 }
    source_lines
  end
end
