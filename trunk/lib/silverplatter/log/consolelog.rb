#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'silverplatter/log/essentials'



module SilverPlatter
	module Log

		# Log.to_console is equivalent to Log::ConsoleLog.new
		def self.to_console(*args)
			Log::ConsoleLog.new(*args)
		end

		# Logs data to STD(ERR/OUT)
		class ConsoleLog
			def initialize(out=nil)
				@out          = out || STDERR
			end
			
			def log_entry(entry)
				@out.puts(ColoredConsole.format(entry))
			end
		end
	end
end
