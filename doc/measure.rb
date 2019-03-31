#!/usr/bin/env ruby

require "bundler/setup"
require 'malloc_trim'

PS_RSS_REGEX=/\D+#{Process.pid}\s+\S+\s+\S+\d+\s+(\d+)/

path = ARGV.first || 'rss.log'
puts "logging to #{path}"
@logfile = File.open(path, 'w')
def measure
  rss = `ps aux`.lines.grep(PS_RSS_REGEX).first.match(PS_RSS_REGEX)[1]
  time = Time.now - @start_time
  @logfile.write("#{time},#{rss}\n")
end

@times_worked = 0
def work
  1.times { a= []; 1_000_000.times { a << a.size.to_s}; }
  @times_worked += 1
end

def no_clean; end
def gc_trim
  GC.start
  MallocTrim.trim
end
def autotrim
  return if @already_enabled
  MallocTrim.enable_trimming
  @already_enabled = true
end

# no_clean   5.8890778870066365 work/sec (2945 runs in 500.0782901 seconds)
# gc_trim    5.343061319232702  work/sec (2672 runs in 500.0878411 seconds)
# autotrim   5.809774973471818  work/sec (2905 runs in 500.0193662 seconds)
# arena_max  6.038712373814729 work/sec (3020 runs in 500.1066143 seconds)
# arena_trim 
def clean
  # no_clean
  gc_trim
  # autotrim
end

puts "press <enter> to stop measuring.."
stop_thread = Thread.new do
  STDIN.gets
  puts ".. stopping"
end
@start_time = Time.now
while stop_thread.alive? && (Time.now - @start_time) <= 500
  work
  clean
  measure
end
stop_thread.kill if stop_thread.alive?
work_time_seconds = Time.now - @start_time
@logfile.close

puts "#{@times_worked.to_f / work_time_seconds} work/sec (#{@times_worked} runs in #{work_time_seconds} seconds)"
