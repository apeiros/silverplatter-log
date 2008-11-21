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
			def debug(text, origin=nil, data=nil, flags=nil)
				log_entry(::SilverPlatter::Log::Entry.new(text, :debug, origin||caller(1), data, flags))
			end

			# See Log::info
			# Calls log_entry passing it a Log::Entry with severity :info and origin caller(1)
			def info(text, origin=nil, data=nil, flags=nil)
				log_entry(::SilverPlatter::Log::Entry.new(text, :info, origin||caller(1), data, flags))
			end

			# See Log::warn
			# Calls log_entry passing it a Log::Entry with severity :warn and origin caller(1)
			def warn(text, origin=nil, data=nil, flags=nil)
				log_entry(::SilverPlatter::Log::Entry.new(text, :warn, origin||caller(1), data, flags))
			end
	
			# See Log::error
			# Calls log_entry passing it a Log::Entry with severity :error and origin caller(1)
			def error(text, origin=nil, data=nil, flags=nil)
				log_entry(::SilverPlatter::Log::Entry.new(text, :error, origin||caller(1), data, flags))
			end
	
			# See Log::fail
			# Calls log_entry passing it a Log::Entry with severity :fatal and origin caller(1)
			def fatal(text, origin=nil, data=nil, flags=nil)
				log_entry(::SilverPlatter::Log::Entry.new(text, :fatal, origin||caller(1), data, flags))
			end
			
			# See Log::exception
			# Calls log_entry passing it a Log::Entry with severity :error and origin caller(1)
			# The log entry will have the exception.message as text and [exception, data] as
			# data.
			def exception(e, data=nil, flags=nil)
				flags ||= []
				flags << :exception
				log_entry(::SilverPlatter::Log::Entry.new(e.message, :error, e.backtrace, [e, data], flags))
			end
		end
	end
end
