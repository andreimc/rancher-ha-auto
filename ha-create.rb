#!/usr/bin/env ruby

require 'optparse'
require_relative 'rancher_generator'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ha-create.rb [options]"

  opts.on("-uURL", "--url=URL", "Rnacher temp url: eg http://127.0.0.1:8080/admin/ha") do |url|
    options[:url] = url
  end

  opts.on("-nNODES", "--nodes=NODES", "HA nodes: 1,3,5") do |nodes|
    options[:ha_nodes] = nodes
  end

  opts.on("-fFQDN", "--fqdn=FQDN", "rancher fqdn url: rancher.example.com") do |fq|
    options[:fqdn_url] = fq
  end
end.parse!

RancherGenerator.new(options).configure_ha

