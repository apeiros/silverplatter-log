#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module SilverPlatter
	module Log
		class Formatter
			def initialize(levels=nil, &generic)
				raise ArgumentError, "Needs a block or an argument" unless levels or generic
				@formatters = Hash.new(generic).merge(levels || {})
			end

			def format(entry)
				formatter = @formatters[entry.severity]
				formatter ? formatter.call(entry) : entry.to_s
			end
		end
	end
end
