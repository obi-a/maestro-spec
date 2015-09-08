#Maestro
Improved DSL for the Website Transaction Monitor here: https://github.com/obi-a/uptime_monitor

##Usage:
```ruby
actions = <<-eos
  exists do
    text_field.where("id": "name").set("john")
  end
eos

monitor = {
  monitor: "My Blog title tag",
  url: "http://obi-akubue.org",
  every: "5m",
  contact: "admin@obiora.com",
  via: "gmail_notifier",
  plugin: "uptime_monitor",
  exists?: Hercules::Parser.parse(actions),
  browser: ["firefox"]
}

ragios.create(monitor)
```


##Spec for transactions
```ruby
##Validations
exists do
  h1
  div
end

###HTML Elements
exists do
  h1
  div
  a
  img
  span
end

exists do
  div.where(class: "box_content")
end

exists do
  img.where(src: "https://fc03.deviantart.net/fs14/f/2007/047/f/2/Street_Addiction_by_gizmodus.jpg"  )
end

exists do
  div.where(id: "test", class: "test-sectionn" )
end

##Using CSS Selectors
exists do
  element.where(css: "#rss-link")
end

#<div data-brand="toyota">
exists do
  element.where(css: '[data-brand="toyota"]')
end

##Helper for HTML elements
#links
a.where(text: "click here")

#using the helper
link.where(text: "click here")

link.where(href: "https://www.southmunn.com/aboutus")

#buttons
button.where(id: "searchsubmit")

#text fields
text_field.where(id: "search")

#checkboxes
checkbox.where(value: "butter")

#radio buttons
radio.where(name: "group1", value: "milk")

#to be continued


exists do
  title.where("text": "obiora")
end

exists do
  link.where("id": "aboutus").click
end

exists do
  text_field.where("id": "name").set("john")
end
```