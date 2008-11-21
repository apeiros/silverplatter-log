#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'silverplatter/log/entry'
require 'silverplatter/log/essentials'
require 'silverplatter/log/puts'



module SilverPlatter
	module Log

		# Log.collect is equivalent to Log::Collector.new
		def self.collect(*args)
			Log::Collector.new(*args)
		end
	
		# == Summary
		# IO drop in replacement that converts calls to puts/write to log_entry
		# calls.
		#
		# == Synopsis
		#   require 'silverplatter/log/collector'
		#   include SilverPlatter
		#   $stderr = Log::Collector.new(Log::ConsoleLog.new(STDERR))
		#   $stderr = Log.collect(Log.to_console(STDERR) # the same, shorter
		#
		# == Description
		# Converts calls to puts with String or Log::Entry as arguments to calls to
		# log_entry (always with Log::Entry as argument).
		# Stores calls to write, print, printf and << in a buffer and calls log_entry
		# upon completed lines.
		#
		# == Notes
		# Accepts and won't modify Log::Entry objects passed to Collector#puts
		#
		# DO NOT call write and puts intermittedly. If you use write and puts
		# mixed and call puts before you wrote a full line (terminating with \n)
		# via write, the content of write will be withheld and the puts done before.
		#
		# DO NOT use this class in a threaded environment where multiple threads
		# aren't limited to puts calls with Log::Entry objects as arguments.
		#
		# Following methods might be useful to be implemented:
		#   binmode, fcntl, fileno, flush, fsync, isatty, lineno, lineno=, pid, pos,
		#   pos=, , scanf, seek, stat, sync, sync=, sysread, tell, to_i,
		#   to_io, tty?
		#
		# Following write methods are NOT implemented:
		#   syswrite, write_nonblock
		#
		# All read methods must be implemented by the including class
		#     
		class Collector
			include Puts
		
			# Severity that will be set for every string converted to a Log::Entry
			attr_accessor :severity

			# The flags that will be set for every string converted to a Log::Entry
			attr_accessor :flags
		
			# Create a new Collecter instance.
			# == Arguments
			# logger:: Any object that responds to .log_entry (every Log::*Log class does)
			def initialize(logger, severity=:warn, *flags)
				@buffer   = ""
				@logger   = logger
				@severity = severity
				@flags    = flags
			end

			# Read completed lines, remove them from the buffer and `puts` them.
			def process_buffer #:nodoc:
				while line = @buffer.slice!(/.*\n/)
					@logger.log_entry(Entry.new(line.chomp, @severity, caller(2), nil, *@flags))
				end
			end
			
			# Forward to logging device
			def log_entry(entry)
				@logger.log_entry(entry)
			end
			
			def <<(obj) # :nodoc:
				@buffer << obj.to_s
				process_buffer
				obj
			end
	
			def write(*objs) # :nodoc:
				@buffer << objs.join(EmptyString)
				process_buffer
			end
			alias print write
	
			def printf(*args) # :nodoc:
				@buffer << sprintf(*args)
				process_buffer
			end
		end
	end
end
