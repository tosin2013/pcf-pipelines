#!/usr/bin/ruby

require 'yaml'

cc = YAML.load(STDIN.read)
static = cc['networks'].find {|x| x["name"] == "DYNAMIC-SERVICES"}['subnets'][0]['static']
if static.nil? then 
  static = cc['networks'].find {|x| x["name"] == "DYNAMIC-SERVICES"}['subnets'][0]['static'] = []
end
if !static.any? then
  static.push(ENV['DYNAMIC_SERVICES_NETWORK_STATIC_IPS'])
end

puts YAML.dump(cc)

