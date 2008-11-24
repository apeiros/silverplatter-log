#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module SilverPlatter
	module Log
		# == Summary
		# Converts calls to puts to calls to log_entry.
		#
		# == Description
		# Log::Entry instances and objects returning true on log_entry? calls are
		# passed on unchanged.
		#
		# Exceptions are wrapped into a Log::Entry using Exception#message as text,
		# a severity of :error, Exception.backtrace as origin, [exception] as data and
		# a single flag 'exception'.
		#
		# All other objects use that object.to_s as message, @severity as severity,
		# caller(1) as origin and a single flag 'puts'.
		#
		module Puts

			# Convert strings to Log::Entry, keep Log::Entry objects as is.
			# Pass them on to @logger.log_entry.
			def puts(*objs) # :nodoc:
				for obj in objs
					case obj
						when ::SilverPlatter::Log::Entry
							log_entry(obj)
						when ::Exception
							log_entry(::SilverPlatter::Log::Entry.new(
								obj.message, :error, obj.backtrace, [obj], %w'exception'
							))
						when ::String
							log_entry(::SilverPlatter::Log::Entry.new(
								obj.chomp, (@severity || :info), caller(1), nil, %w'puts'
							))
						else
							if obj.log_entry? then
								log_entry(obj)
							else
								log_entry(::SilverPlatter::Log::Entry.new(
									obj.to_s.chomp, (@severity || :info), caller(1), nil, %w'puts'
								))
							end
					end # case
				end # for
				nil
			end
		end
	end
end
