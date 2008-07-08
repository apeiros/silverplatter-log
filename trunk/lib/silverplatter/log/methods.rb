#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module SilverPlatter
	module Log

		# Provides convenience mappings to #log_entry
		module Methods
			# See Log::debug
			# Calls log_entry passing it a Log::Entry with severity :debug and origin caller(1)
			def debug(text, *args)
				log_entry(::SilverPlatter::Log::Entry.new(text, :debug, caller(1), *args))
			end

			# See Log::info
			# Calls log_entry passing it a Log::Entry with severity :info and origin caller(1)
			def info(text, *args)
				log_entry(::SilverPlatter::Log::Entry.new(text, :info, caller(1), *args))
			end

			# See Log::warn
			# Calls log_entry passing it a Log::Entry with severity :warn and origin caller(1)
			def warn(text, *args)
				log_entry(::SilverPlatter::Log::Entry.new(text, :warn, caller(1), *args))
			end
	
			# See Log::error
			# Calls log_entry passing it a Log::Entry with severity :error and origin caller(1)
			def error(text, *args)
				log_entry(::SilverPlatter::Log::Entry.new(text, :error, caller(1), *args))
			end
	
			# See Log::fail
			# Calls log_entry passing it a Log::Entry with severity :fatal and origin caller(1)
			def fatal(text, origin=nil, *args)
				log_entry(::SilverPlatter::Log::Entry.new(text, :fatal, caller(1), *args))
			end
			
			# See Log::exception
			# Calls log_entry passing it a Log::Entry with severity :error and origin caller(1)
			# The log entry will have the exception.message as text and [exception, data] as
			# data.
			def exception(e, data=nil, *args)
				log_entry(
					if flags.first.is_a?(Time) then
						::SilverPlatter::Log::Entry.new(e.message, caller(1), [e, data], flags.shift, :exception, *flags)
					else
						::SilverPlatter::Log::Entry.new(e.message, caller(1), [e, data], :exception, *flags)
					end
				)
			end
		end
	end
end
