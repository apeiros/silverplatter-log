#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module SilverPlatter
	module Log

		# Provides convenience mappings to #process
		# Map debug, info, warn, error, fail to log_entry
		module Methods
			# See Log::debug
			def debug(text, *args)
				log_entry(::SilverPlatter::Log::Entry.new(text, :debug, *args))
			end

			# See Log::info
			def info(text, *args)
				log_entry(::SilverPlatter::Log::Entry.new(text, :info, *args))
			end

			# See Log::warn
			def warn(text, *args)
				log_entry(::SilverPlatter::Log::Entry.new(text, :warn, *args))
			end
	
			# See Log::error
			def error(text, *args)
				log_entry(::SilverPlatter::Log::Entry.new(text, :error, *args))
			end
	
			# See Log::fail
			def fail(text, *args)
				log_entry(::SilverPlatter::Log::Entry.new(text, :fail, *args))
			end
			
			# See Log::exception
			def exception(e, *args)
				log_entry(::SilverPlatter::Log::ExceptionEntry.new(e, *args))
			end
		end
	end
end
