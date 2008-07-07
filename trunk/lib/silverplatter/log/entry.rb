#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'enumerator'
require 'silverplatter/log'



module SilverPlatter
	module Log

		# == Summary
		# Represents a single entry in a log
		#
		# == Synopsis
		# require 'silverplatter/log/entry'
		# SilverPlatter::Log::Entry.new("text", :warn, caller(0), additionaldata)
		class Entry
			# Serialization format.
			# Currently *only* used by Entry#serialize, but not by Entry::deserialize
			Serialized =
				"%d#{RecordSeparator}" \
				"%s#{RecordSeparator}" \
				"%s#{RecordSeparator}" \
				"%s#{RecordSeparator}" \
				"%s#{RecordSeparator}" \
				"%s".freeze

			# Template used for inspect
			InspectTemplate = "#<%s %s %s %s %s flags=%s data=%s>".freeze

			# Template for to_s without formatter
			DefaultFormat	= "[%s@%s] %s in %s".freeze

			class <<self
				attr_accessor :time_format
				
				# === Summary
				# Create an Entry from the String of a serialized Entry.
				#
				# === Synopsis
				#   Log::Entry.deserialize(Log::Entry.new("text".serialize)).text # => "text"
				def deserialize(line)
					time, severity, origin, text, flagstr, data = line.chomp(RecordTerminator).split(RecordSeparator)
					flags = {}
					flagstr.split(UnitSeparator).each_cons(2) { |key, value|
						flagstr[key] = value
					}
					severity = Integer(severity) rescue severity
					new(
						text,
						InvSeverity[severity],
						Log.unescape(origin),
						Marshal.load(Log.unescape(data)),
						Time.at(time.to_i),
						flags
					)
				end
			end
	
			Severity = Hash.new{|h,k|k}.merge({
				:debug => 1,
				:info  => 2,
				:warn  => 4,
				:error => 8,
				:fatal => 16,
			})
			InvSeverity = Severity.invert

			# Time the log entry was created
			attr_reader :time
			
			# Severity of this log entry (debug, info, warn, error or fatal)
			attr_reader :severity
			
			# Location the entry originated (usually the return value of Kernel#caller)
			attr_reader :origin
			
			# The message of the entry
			attr_reader :text
			
			# Flags set for this entry (any arbitrary symbol)
			attr_reader :flags
			
			# Data payload (anything Marshallable)
			attr_reader :data

			# Formatter for this entry (Log::Formatter instance)
			attr_accessor :formatter

			def initialize(text, severity=:info, origin=nil, data=nil, *flags)
				@time      = flags.first.kind_of?(Time) ? flags.shift : Time.now
				@severity  = severity
				@origin    = Array(origin)
				@text      = text
				@data      = data
				@flags     = flags.last.kind_of?(Hash) ? flags.pop : {}
				@flags.each_key { |k,v| @flags[k.to_s] = @flags.delete(k) } # convert keys to strings
				flags.each { |flag| @flags[flag.to_s] = true }
				@formatter = nil
			end
			
			def eql?(other) # :nodoc:
				self.class == other.class &&
				@severity.equal?(other.severity) &&
				@text.eql?(other.text) &&
				@origin.eql?(other.origin) &&
				@flags == other.flags
			end
			
			def hash # :nodoc:
				[@severity, @text, @origin].hash
			end
			
			def [](key)
				@flags[key]
			end
			
			def log_entry?
				true
			end
			
			# True if the log-level is :debug, false otherwise
			def debug?
				@severity == :debug
			end
	
			# True if the log-level is :info, false otherwise
			def info?
				@severity == :info
			end
	
			# True if the log-level is :warn, false otherwise
			def warn?
				@severity == :warn
			end
	
			# True if the log-level is :error, false otherwise
			def error?
				@severity == :error
			end
	
			# True if the log-level is :fatal, false otherwise
			def fatal?
				@severity == :fatal
			end

			# Returns a String that can be deserialized to a Log::Entry using
			# Log::Entry::deserialize. You can use RecordTerminator to join multiple
			# serialized entries savely.
			# Also see Log::LogReader
			def serialize
				sprintf Serialized,
					@time,
					Severity[@severity],
					Log.escape(Marshal.dump(@origin)),
					Log.escape(@text),
					@flags.map.join(UnitSeparator),
					Log.escape(Marshal.dump(@data))
				# /sprintf
			end
		
			def to_s(format=nil)
				if format ||= @format then
					format.format(self)
				else
					sprintf DefaultFormat,
						@time.strftime('%FT%T'),
						@severity,
						@text,
						@origin.first
					# /sprintf
				}
			end
			
			def inspect # :nodoc:
				sprintf InspectTemplate,
					self.class,
					@time.strftime("%FT%T"),
					@severity,
					@origin.first,
					@text.inspect,
					@flags.inspect,
					@data.inspect
				# /sprintf
			end
		end
	end
end
