#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



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
		#   $stderr = SilverPlatter::Log::Collector.new(
		#     Silverplatter::Log::MultiLog(
		#       Silverplatter::Log::ConsoleLog(opts),
		#       Silverplatter::Log::FileLog(path, opts)
		#       Silverplatter::Log::ProcessLog(process, opts)
		#     ), :warn
		#   )
		#
		# === Description
		# Forwards all calls on puts to it to all its
		# receivers. Calls on write are buffered to newlines
		# and then forwarded as a puts.
		#
		class MultiLog
			# Create a MultiLog instance. 
			def initialize(*receivers)
				@buffer    = ""
				@receivers = receivers
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
