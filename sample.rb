require 'treetop'

Treetop.load 'maestro'

#parser = MaestroParser.new

actions = <<-eos
  exists do
    h1
    div
    hoj
  end
eos

#actions = "  exists do div end"

actions = <<-eos
  exists do
    div.where(id: "test", class: "test-sectionn" )
    element.where(css: "[data-brand='toyota']")
  end
eos

#syntax_tree = parser.parse( actions.gsub(/\n|\t/, "") )

#puts syntax_tree.inspect

def parse(data)
  if data.respond_to? :read
    data = data.read
  end

  parser = MaestroParser.new
  ast = parser.parse data

  if ast
    puts ast.inspect
  else
    parser.failure_reason =~ /^(Expected .+) after/m
    puts "#{$1.gsub("\n", '$NEWLINE')}:"
    puts data.lines.to_a[parser.failure_line - 1]
    puts "#{'~' * (parser.failure_column - 1)}^"
  end
end

parse(actions)
