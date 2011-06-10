Gem::Specification.new do |s|
  s.name = %q{hamdown}
  s.version = "0.0.13"
  s.date = %q{2011-05-15}
  s.authors = ["Robert Fletcher"]
  s.email = %q{lobatifricha@gmail.com}
  s.summary = %q{Hamdown converts a markdown file to html and plops it into a haml template}
  s.homepage = %q{https://github.com/mockdeep/hamdown}
  s.description = %q{Hamdown converts a markdown file to html and plops it into a haml template}
  s.files = %w[
    lib/hamdown.rb
    bin/hamdown
  ]
  s.executables = ["hamdown"]
  s.add_dependency('rdiscount', '>= 1.6.8')
  s.add_dependency('haml', '>= 3.1.1')
  s.add_dependency('trollop', '>= 1.16.2')
end
