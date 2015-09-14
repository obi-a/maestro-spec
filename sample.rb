require 'treetop'

Treetop.load 'maestro'

parser = MaestroParser.new

actions = <<-eos
  exists do
    div
  end
eos

syntax_tree = parser.parse( actions.gsub(/\n|\t/, "") )

puts syntax_tree.inspect
