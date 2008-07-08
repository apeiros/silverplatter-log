#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'silverplatter/log/iolog'



module SilverPlatter
	module Log
		# Log.to_file is equivalent to Log::FileLog.new
		def self.to_file(*args)
			Log::FileLog.new(*args)
		end
	
		# == Summary
		# Logs data to file
		#
		# == Synopsis
		#   require 'silverplatter/log/filelog'
		#   obj.logger = Log.to_file('path/to/file')
		class FileLog < IOLog

			# See Log::FileLog for more information.
			def initialize(path, append=true)
				super(File.open(path, append ? 'ab' : 'wb'))
			end
		end
	end
end
