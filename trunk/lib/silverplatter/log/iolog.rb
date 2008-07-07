#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module SilverPlatter
	module Log
		# Log.to_file is equivalent to Log::File.new
		def self.to_io(*args)
			Log::IOLog.new(*args)
		end
	
		# Logs data to file
		class IOLog
			def initialize(io)
				raise ArgumentError, "io must respond to :puts" unless io.respond_to?(:puts)
				@io = io
			end
			
			def log_entry(entry)
				@io.puts entry
			end
		end
	end
end
