#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module SilverPlatter
	module Log
		# Log.file is equivalent to Log::File.new
		def self.to_console(*args)
			Log::ConsoleLog.new(*args)
		end

		# Logs data to STD(ERR/OUT)
		class ConsoleLog
			def initialize(out=nil)
				@out          = out || STDERR
			end
			
			def log_entry(entry)
				case entry.severity
					when :debug # 46 (45)
						@out.puts "\e[46m\e[30m\e[1m DEBUG \e[0m #{entry.time.strftime('%a %H:%M:%S')}: #{entry.text} in #{entry.origin.first}"
					when :info # 44
						@out.puts "\e[44m\e[30m\e[1m INFO  \e[0m #{entry.time.strftime('%a %H:%M:%S')}: #{entry.text}"
					when :warn # 43
						@out.puts "\e[43m\e[30m\e[1m WARN  \e[0m #{entry.time.strftime('%a %H:%M:%S')}: #{entry.text} in #{entry.origin.first}"
					when :error # 41
						@out.puts "\e[41m\e[30m\e[1m ERROR \e[0m #{entry.time.strftime('%a %H:%M:%S')}: #{entry.text} in #{entry.origin.first}"
					when :fatal # 41
						@out.puts "\e[5m\e[41m\e[30m\e[1m FATAL \e[0m #{entry.time.strftime('%a %H:%M:%S')}: #{entry.text} in #{entry.origin.first}"
				end
			end
		end
	end
end
