#!/usr/bin/ruby

require 'yaml'

cc = YAML.load(string)
static = cc['networks'].find {|x| x["name"] == "services"}["static"]
if static.any? then
  static.push(ENV['SERVICES_NETWORK_STATIC_IPS'])
end

puts YAML.dump(cc)
