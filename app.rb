#!/usr/bin/env ruby

require 'bundler/setup'
require_relative 'lib/aws_ip_ranges'
require_relative 'lib/sshuttle_proxy'
require_relative 'lib/cli'

if __FILE__ == $PROGRAM_NAME
  options = CLI.parse(ARGV)
  
  if options[:region].nil? || options[:ssh_host].nil?
    puts "Error: Region and SSH host are required."
    puts CLI.parse(["-h"])
    exit 1
  end

  proxy = SSHuttleProxy.new(options[:region], options)
  proxy.run
end
