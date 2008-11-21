#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'silverplatter/log/essentials'
require 'silverplatter/log/puts'



module SilverPlatter
	module Log

		# Log.to_console is equivalent to Log::ConsoleLog.new
		def self.to_console(*args)
			Log::ConsoleLog.new(*args)
		end

		# === Summary
		# Logs data colored to STDOUT
		#
		# === Synopsis
		#   require 'silverplatter/log/consolelog'
		#   require 'silverplatter/log/collector'
		#   include SilverPlatter
		#   # Log.collect is required due to the #write method
		#   $stdout = Log.collect(Log.to_console, :info)
		#   $stderr = Log.collect($stdout, :warn)
		#   warn "foo"
		#   puts "bar"
		#
		class ConsoleLog
			include Puts

			# See Log::ConsoleLog for more information.
			def initialize
				@severity = :info
			end

			# Log an entry to STDOUT.
			def log_entry(entry)
				# STDOUT instead of $stdout so $stdout can be wrapped with a logger.
				STDOUT.puts(ColoredConsole.format(entry))
			end
		end
	end
end
