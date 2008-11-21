#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module SilverPlatter
	module Log
		def self.discard
			Log::NoLog.new
		end

		# == Summary
		# Discards all logging. Can act as drop-in IO replacement.
		#
		# == Synopsis
		#   require 'silverplatter/log/nolog'
		#   obj.logger = Log.discard
		class NoLog
			def log_entry(entry) # :nodoc:
			end
			def puts(*args) # :nodoc:
			end
			def write(*args) # :nodoc:
			end
			def <<(args) # :nodoc:
			end
			def print(*args) # :nodoc:
			end
			def printf(*args) # :nodoc:
			end
		end
	end
end
