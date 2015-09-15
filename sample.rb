require 'treetop'

Treetop.load 'maestro'

#parser = MaestroParser.new

actions = <<-eos
  exists do
    h1
    div
  end
eos

#actions = "  exists do div end"

#actions = "h1"

#syntax_tree = parser.parse( actions.gsub(/\n|\t/, "") )

#puts syntax_tree.inspect

def parse(data)
  if data.respond_to? :read
    data = data.read
  end

  parser = MaestroParser.new
  ast = parser.parse data

  if ast
    ast.do_something_useful
  else
    parser.failure_reason =~ /^(Expected .+) after/m
    puts "#{$1.gsub("\n", '$NEWLINE')}:"
    puts data.lines.to_a[parser.failure_line - 1]
    puts "#{'~' * (parser.failure_column - 1)}^"
  end
end

parse(actions)
