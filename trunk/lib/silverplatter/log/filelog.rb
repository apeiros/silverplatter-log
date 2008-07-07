#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'silverplatter/log/iolog'



module SilverPlatter
	module Log
		# Log.to_file is equivalent to Log::File.new
		def self.to_file(*args)
			Log::FileLog.new(*args)
		end
	
		# Logs data to file
		class FileLog < IOLog
			def initialize(path, append=true)
				super(File.open(path, append ? 'ab' : 'wb'))
			end
		end
	end
end
