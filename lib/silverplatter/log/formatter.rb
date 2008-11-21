#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module SilverPlatter
	module Log
	
		# == Summary
		# Formatter stores procs to format Log::Entry's
		#
		# == Synopsis
		#   require 'silverplatter/log/formatter'
		#   Formatter.new { |entry| "Format all messages like this #{entry.text}" }
		#   Formatter.new(
		#     :debug => proc { |entry| "Only debug messages like this" },
		#     :info  => proc { |entry| "Info's like this" }
		#   ) { |entry| "And all others like this" }
		#
		class Formatter
			# Create a new Formatter.
			# See the class description for a synopsis
			def initialize(levels=nil, &generic)
				raise ArgumentError, "Needs a block or an argument" unless levels or generic
				@formatters = Hash.new(generic).merge(levels || {})
			end

			# Format an entry according to this formatter
			def format(entry)
				formatter = @formatters[entry.severity]
				formatter ? formatter.call(entry) : entry.to_s
			end
		end
	end
end
