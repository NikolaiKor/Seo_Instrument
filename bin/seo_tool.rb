#!/usr/bin/env ruby
require_relative '../config/configuration'
STDOUT.puts "Welcome to seo tool command interface. Saving format: #{Configuration.storage_type}"
STDOUT.puts "Write site's URL and press Enter\nUrl:"
_url = ARGV[0]
if _url.nil?
  STDOUT.puts "Write site's URL, but not empty string\nUrl:"
else
  STDOUT.puts "Connecting to #{_url}..."
  _info =RequestWorker.new.get_info(_url)
  STDOUT.puts "Done\nFile identifier: #{_info.identifier}"
end