require 'treetop'

Treetop.load 'browsers'

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
  title.with_text("All Watches Shop, Authentic Watches at Akross")
  text_field.where(name: "filter_name").set("citizen")
  div.where(class: "button-search").click
  title.with_text("search")
  link.where(text: "search")
  button.where(value: "Add to Cart").click
  link.where(text: "Checkout").click
  title.with_text("Checkout")
eos

actions = "firefox    headless "
#puts actions.inspect

#syntax_tree = parser.parse( actions.gsub(/\n|\t/, "") )

#puts syntax_tree.inspect

def parse(data)
  if data.respond_to? :read
    data = data.read
  end

  parser = BrowsersParser.new
  ast = parser.parse data

  if ast
    puts ast.content.inspect
  else
    parser.failure_reason =~ /^(Expected .+) after/m
    puts "#{$1.gsub("\n", '$NEWLINE')}:"
    puts data.lines.to_a[parser.failure_line - 1]
    puts "#{'~' * (parser.failure_column - 1)}^"
  end
end

parse(actions)
