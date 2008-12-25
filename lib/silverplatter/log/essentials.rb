#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'silverplatter/log/formatter'



module SilverPlatter
	module Log
		GroupSeparator   = "\x1d".freeze # :nodoc:
		RecordSeparator  = "\x1e".freeze # :nodoc:
		UnitSeparator    = "\x1f".freeze # :nodoc:
		RecordTerminator = "\n".freeze   # :nodoc:
		EmptyString      = "".freeze     # :nodoc:
		
		# print color codes for log level, print whole backtrace on error and fatal.
		ColoredDebugConsole   = Formatter.new({
			:debug => proc { |e|
				"\e[46m\e[30m\e[1m DEBUG \e[0m #{e.time.strftime('%a %H:%M:%S')}: #{e.text} in #{e.origin.first}"
			},
			:info  => proc { |e|
				"\e[44m\e[30m\e[1m INFO  \e[0m #{e.time.strftime('%a %H:%M:%S')}: #{e.text} in #{e.origin.first}"
			},
			:warn  => proc { |e|
				"\e[43m\e[30m\e[1m WARN  \e[0m #{e.time.strftime('%a %H:%M:%S')}: #{e.text} in #{e.origin.first}"
			},
			:error => proc { |e|
				"\e[41m\e[30m\e[1m ERROR \e[0m #{e.time.strftime('%a %H:%M:%S')}: #{e.text} in\n  #{e.origin.join("\n  ")}"
			},
			:fatal => proc { |e|
				"\e[5m\e[41m\e[30m\e[1m FATAL \e[0m #{e.time.strftime('%a %H:%M:%S')}: #{e.text} in\n  #{e.origin.join("\n  ")}"
			},
		})
		ColoredConsole   = Formatter.new({
			:debug => proc { |e|
				"\e[46m\e[30m\e[1m DEBUG \e[0m #{e.time.strftime('%a %H:%M:%S')}: #{e.text} in #{e.origin.first}"
			},
			:info  => proc { |e|
				"\e[44m\e[30m\e[1m INFO  \e[0m #{e.time.strftime('%a %H:%M:%S')}: #{e.text} in #{e.origin.first}"
			},
			:warn  => proc { |e|
				"\e[43m\e[30m\e[1m WARN  \e[0m #{e.time.strftime('%a %H:%M:%S')}: #{e.text} in #{e.origin.first}"
			},
			:error => proc { |e|
				"\e[41m\e[30m\e[1m ERROR \e[0m #{e.time.strftime('%a %H:%M:%S')}: #{e.text} in #{e.origin.first}"
			},
			:fatal => proc { |e|
				"\e[5m\e[41m\e[30m\e[1m FATAL \e[0m #{e.time.strftime('%a %H:%M:%S')}: #{e.text} in #{e.origin.first}"
			},
		})
		HumanReadableFile = Formatter.new { |e|
			"[#{e.severity.to_s.downcase}@#{e.time.strftime('%a %H:%M:%S')}] #{e.text} in #{e.origin.first}"
		}

		# Mapping from severity-symbol to integer
		Severity = Hash.new{|h,k|k}.merge({
			:debug => 1,
			:info  => 2,
			:warn  => 4,
			:error => 8,
			:fail  => 16,
		})
		
		# Reverse mapping to Severity. Maps an integer to a Symbol.
		InvSeverity = Severity.invert

		# escape binary data, the data will contain no \n, \r or \t's after escaping, but
		# still contain binary characters, but all of them preceeded by \e
		def self.escape(data)
			data.
				gsub(/\e/, "\e\e").
				gsub(/\n/, "\en").
				gsub(/\r/, "\er").
				gsub(/\t/, "\et").
				gsub(/[\x00-\x1a\x1c-\x1f]/, "\e\\0")
		end
		
		# unescapes data escaped by Log.escape
		def self.unescape(data)
			data.
				gsub(/\en/, "\n").
				gsub(/\er/, "\r").
				gsub(/\et/, "\t").
				gsub(/\e(.)/, '\1')
		end
	end
end

class Object
	# Per default no object is a log_entry?.
	def log_entry?
		false
	end
end
