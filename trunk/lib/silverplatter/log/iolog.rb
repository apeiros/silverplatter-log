#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'silverplatter/log/puts'



module SilverPlatter
	module Log
		# Log.to_io is equivalent to Log::IOLog.new
		def self.to_io(*args)
			Log::IOLog.new(*args)
		end
	
		# == Summary
		# Logs data to an IO via IO#puts.
		#
		# == Synopsis
		#   require 'silverplatter/log/iolog'
		#   obj.logger = Log.to_io(TCPSocket.open(logserver, logport))
		class IOLog
			include Puts

			# See Log::IOLog for more information.
			def initialize(io)
				raise ArgumentError, "io must respond to :puts" unless io.respond_to?(:puts)
				@io       = io
				@severity = :info # for Log::Puts
			end
			
			# Log an entry to the io-loggers IO.
			def log_entry(entry)
				@io.puts entry
			end
		end
	end
end
