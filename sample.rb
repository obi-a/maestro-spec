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
