#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'silverplatter/log/iolog'



module SilverPlatter
	module Log
		# Log.to_process is equivalent to Log::ProcessLog.new
		def self.to_process(*args)
			Log::IOLog.new(*args)
		end
	
		# == Summary
		# Sends logdata to a process
		#
		# == Synopsis
		#   obj.logger = 
		class ProcessLog
			Writeable = "wb".freeze
			
			# 
			def initialize(process)
				super(IO.popen(process, Writeable))
			end
		end
	end
end
