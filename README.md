#Maestro
Improved DSL for the Website Transaction Monitor here: https://github.com/obi-a/uptime_monitor

##Usage:
```ruby
actions = <<-eos
  text_field.where("id": "name").set("john")
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
h1
div

###HTML Elements
  h1
  div
  a
  img
  span
  div.where(class: "box_content")
  img.where(src: "https://fc03.deviantart.net/fs14/f/2007/047/f/2/Street_Addiction_by_gizmodus.jpg"  )
  div.where(id: "test", class: "test-sectionn" )


##Using CSS Selectors
  element.where(css: "#rss-link")

#<div data-brand="toyota">
  element.where(css: "[data-brand='toyota']")

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

##Drop Down menus
#<select name="mydropdown">
#<option value="Milk">Fresh Milk</option>
#<option value="Cheese">Old Cheese</option>
#<option value="Bread">Hot Bread</option>
#</select>

#with helper
select_list.where(name: "mydropdown")

#or HTML select tag
select.where(name: "mydropdown")

#Options of the drop-down menu can be specified using option
option.where(value: "Milk")
```
##Text Validations
A text validation is used to verify that the text content of a html element hasn't changed. For example,
```ruby
title.with_text("welcome")


```
The above example first verifies that a title tag exists on the page, then it verifies that title tag text is equal to "Welcome to my site".
The following is a text validation:
```ruby
text.with_text("Welcome to my site")
```
Text validations can also verify that the html element's text includes the provided string, in the format below:
```ruby
title.includes_text("Welcome")
```
The above example verifies that the title tag's text includes the string "Welcome".
Another example, to verify that a div with class="box_content" includes the string "SouthMunn is a Website"
```ruby
div.where(class: "box_content").includes_text("SouthMunn is a Website")


#old DSL
exists?: [
           [{div: {class: "box_content"}}, [includes_text: "SouthMunn is a Website"]]
         ]
```
Text validations can be used on html elements that can contain text like title, div, span, h1, h2 etc.

####Actions
Validations can also include actions. The actions are performed on the html element after it is verfied that the element exists. Example to set a text field's value
```ruby
text_field.where(id: "username").set("admin")

```
The above example will set the text field's value to the string "admin".
The following is an action
```ruby
set("admin")
```
#####Actions on html elements
Common actions performed on elements are set, select and click.

Set value for a textfield or textarea.
```ruby
text_field.where(name: "q").set("ruby")
text_area.where(name:"longtext").set("In a world...")
```
Select an option from a drop down menu
```html
<select name="mydropdown">
<option value="Milk">Fresh Milk</option>
<option value="Cheese">Old Cheese</option>
<option value="Bread">Hot Bread</option>
</select>
```
```ruby
select_list.where(name: "mydropdown").select("Old Cheese")
```
Click a radio button, checkbox, link or button
```ruby
radio.where(name: "group1", value: "Milk").click
checkbox.where(name: "checkbox").click
link.where(text: "Click Here").click
button.where(id: "submit").click
```
####Waiting
For webpages that use a lot of AJAX, it's possible to wait until an element exists, by using the wait_for. This key takes an element as value. It is a special type of validation, it will wait for 30 seconds for the provided element to exist, if the element doesn't exist in 30 seconds the validation fails.
```ruby
wait_for div.where(id: "open-section")
```
The above example will wait 30 seconds until the div exists, if it doesn't exist after 30 seconds the validation will fail.

####Multiple validations and actions
```ruby
#new DSL
text_field.where(id: "username").set("admin")
text_field.where(id: "password").set("pass")
button.click
title.includes_text("Dashboard")

#old DSL
exists?: [
            [{text_field: {id: "username"}}, [set: "admin"]],
            [{text_field: {id: "password"}}, [set: "pass"]],
            [:button, [:click]],
            [:title, [includes_text: "Dashboard"]]
         ]
```
With multiple validations like the example above, the monitor will run the validations, line by line, from top to bottom. When it meets an action it will apply it on the element in the validation. The monitor fails it's test if any of the validation fails. So for the monitor to pass, all validations must pass.

When actions like clicking a link, changes the current page, the following validations will be performed on the new page.

A combination of multiple validations and actions form the basis for performing transactions.


####Performing Transactions
Transactions are achieved by a combination of multiple validations and actions.

Example, to monitor the keyword search feature on my blog, notice the validations in the exists? key's value:
```ruby
#new DSL
actions = <<-eos
  title.with_text("Obi Akubue")
  text_field.where(id: "s").set("ruby")
  button.where(id: "searchsubmit").click
  title.includes_text("ruby").includes_text("Search Results")
  h2.where(class: "pagetitle").includes_text("Search results for")
eos

monitor = {
  monitor: "My Blog: keyword search",
  url: "http://obi-akubue.org",
  every: "1h",
  contact: "admin@obiora.com",
  via: "gmail_notifier",
  plugin: "uptime_monitor",
  exists?: Hercules::Parser.parse(actions),
  browser: ["firefox"]
}


#old DSL
monitor = {
  monitor: "My Blog: keyword search",
  url: "http://obi-akubue.org",
  every: "1h",
  contact: "admin@obiora.com",
  via: "gmail_notifier",
  plugin: "uptime_monitor",
  exists?: [
             [:title,[text: "Obi Akubue"]],
             [{text_field: {id: "s"}}, [set: "ruby"]],
             [{button:{id: "searchsubmit"}}, [:click]],
             [:title, [includes_text: "ruby"], [includes_text: "Search Results"]],
             [{h2:{class: "pagetitle"}},[includes_text: "Search results for"]]
           ],
  browser: ["firefox"]
}
ragios.create(monitor)
```
In the above example the monitor will visit "http://obi-akubue.org" every hour, and perform a search for keyword 'ruby', then confirm that the search works by checking that the title tag and h2 tag of the search results page contains the expected text.

Another example, to search my friend's ecommerce site http://akross.net, for a citizen brand wristwatch, add one to cart, and go to the checkout page.

This transaction verifies the the following about the site:

1. Product search is working

2. Add to cart works

3. Checkout page is reachable

4. All three above works together as a sequence

```ruby
#new DSL
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

monitor = {
  monitor: "Akross.net: Add citizen watch to cart and checkout",
  url: "http://akross.net",
  every: "1h",
  contact: "admin@obiora.com",
  via: "ses",
  plugin: "uptime_monitor",
  exists?: Hercules::Parser.parse(actions),
  browser: ["phantomjs"]
}


#old DSL
monitor = {
  monitor: "Akross.net: Add citizen watch to cart and checkout",
  url: "http://akross.net",
  every: "1h",
  contact: "admin@obiora.com",
  via: "ses",
  plugin: "uptime_monitor",
  exists?: [
             [:title, [text: "All Watches Shop, Authentic Watches at Akross"]],
             [{text_field: {name: "filter_name"}}, [set: "citizen"]],
             [{div: {class: "button-search"}}, [:click]],
             [:title,[text: "Search"]],
             [link: {text: "Search"}],
             [{button: {value: "Add to Cart"}}, [:click]],
             [{link: {text: "Checkout"}}, [:click]],
             [:title, [text: "Checkout"]]
           ],
  browser: ["phantomjs"]
}

ragios.create(monitor)
```


Another example, to monitor the login process of the website http://southmunn.com
```ruby
#new DSL
actions = <<-eos
  title.with_text("Website Uptime Monitoring | SouthMunn.com")
  link.where(text: "login").click
  title.with_text("Sign in - Website Uptime Monitoring | SouthMunn.com")
  text_field.where(id: "username").set("admin")
  text_field.where(id: "password").set("pass")
  button.click
  title.with_text("Dashboard - Website Uptime Monitoring | SouthMunn.com")
eos

login_process = Hercules::Parser.parse(actions)

#old DSL
login_process = [
  [:title, [text: "Website Uptime Monitoring | SouthMunn.com"]],
  [{link: {text:"Login"}}, [:click]],
  [:title, [text: "Sign in - Website Uptime Monitoring | SouthMunn.com"]],
  [{text_field: {id: "username"}}, [set: "admin"]],
  [{text_field: {id: "password"}}, [set: "pass"]],
  [:button, [:click]],
  [:title, [text: "Dashboard - Website Uptime Monitoring | SouthMunn.com"]]
]

monitor = {
  monitor: "My Website login processs",
  url: "https:/southmunn.com",
  every: "1h",
  contact: "admin@obiora.com",
  via: "email_notifier",
  plugin: "uptime_monitor",
  exists?: login_process,
  browser: ["firefox", headless: true]
}
ragios.create(monitor)
```
