#!/usr/bin/ruby

require 'yaml'

cc = YAML.load(STDIN.read)
static = cc['networks'].find {|x| x["name"] == "SERVICES"}['subnets'][0]["static"]
if !static.any? then
  static.push(ENV['SERVICES_NETWORK_STATIC_IPS'])
end

puts YAML.dump(cc)

