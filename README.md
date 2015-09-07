#Maestro

##Spec
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
