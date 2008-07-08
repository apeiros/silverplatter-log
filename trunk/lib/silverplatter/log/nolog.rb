#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module SilverPlatter
	module Log
		# discards all messages
		class NoLog
			def log_entry(entry)
			end
		end
	end
end
