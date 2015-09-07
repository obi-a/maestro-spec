#Maestro

##Specs for monitors

```ruby
monitor do
  title "My blog title"
  url "http://obi-akubue.org"
  every "5m"
  contact "admin@obiora.com"
  via "gmail_notifier"
  plugin "uptime_monitor"
  browser "firefox"
  exists? do
    title.where("text": "obiora")
  end
end

monitor do
  title "My blog title"
  url "http://obi-akubue.org"
  every "5m"
  contact "admin@obiora.com"
  via "gmail_notifier"
  plugin "url_monitor"
end
```
##Spec for website transaction script
```ruby
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
