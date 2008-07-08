#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'silverplatter/log/puts'



module SilverPlatter
	module Log

		# Log.to_all is equivalent to Log::MultiLog.new
		def self.to_all(*args)
			Log::FileLog.new(*args)
		end

		# === Summary
		# Logs to multiple log services at once.
		#
		# === Synopsis
		#   require 'silverplatter/log/multilog'
		#   include SilverPlatter
		#   $stderr = Log.collect( # needed for the write method.
		#     Log.to_all(
		#       Log.to_console,
		#       Log.to_file(path),
		#       Log.to_process("cronolog #{cronolog_path}")
		#     )
		#   )
		#
		# === Description
		# Forwards all calls on puts to it to all its
		# receivers. Calls on write are buffered to newlines
		# and then forwarded as a puts.
		#
		class MultiLog
			include Puts

			# Create a MultiLog instance.
			# See Log::MultiLog for more information.
			def initialize(*receivers)
				@buffer    = ""
				@receivers = receivers
				@severity  = :info # for Puts module
			end
			
			# Add a receiver to the log events
			def __add__(receiver)
				@receivers << receiver
			end

			# Delete a receiver
			def __delete__(receiver)
				@receivers.delete(receiver)
			end
			
			# Iterate over all receivers
			# Note: Does not include Enumerable to avoid clashes.
			def each(&block)
				@receivers.each(&block)
			end
			
			# Log an entry to all the loggers registered to this multilog.
			def log_entry(entry)
				for receiver in @receivers
					receiver.log_entry(entry)
				end
			end
			
			def inspect
				sprintf "#<%s:%08x %p>",
					self.class,
					object_id<<1,
					@receivers
				# /sprintf
			end
		end # MultiLog
	end # Log
end # SilverPlatter
