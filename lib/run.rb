#!/usr/bin/env ruby

load 'code_challenge.rb'

#cc = CodeChallenge.new()

if !CodeChallenge.validate_input
  puts "usage: codechallange message"
  exit();
end

message = ARGV[0]

if !CodeChallenge.keys_exist
  CodeChallenge.generate_keys(message)
  CodeChallenge.output_data(message)
else
  CodeChallenge.output_data(message)
end

