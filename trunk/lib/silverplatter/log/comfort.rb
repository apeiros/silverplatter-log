#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'silverplatter/log/entry'



module SilverPlatter
	module Log

		# == Description
		# Log::Comfort provides some convenience methods for any class that includes
		# and any object that extends it.
		#
		# == Synopsis
		# include SilverPlatter::Log::Comfort
		# log("Some info")
		# log("Danger!", :warn)
		# warn("Danger!")
		# debug("mecode was here")
		# rescue => e; exception(e); end
		#
		# == Notes
		# If you include Log::Comfort, you should initialize @logger within initialize.
		# If you extend with Log::Comfort, Log::Comfort will initialize it with nil.
		#
		module Comfort
			def self.extended(obj) # :nodoc:
				obj.logger ||= nil
			end

			# where data is logged to
			attr_accessor :logger
	
			# See Log::log
			# Comfort#log uses @logger || $stderr as logging device.
			def log(text, severity=:info, data=nil, *flags)
				(@logger || $stderr).puts(
					::SilverPlatter::Log::Entry.new(text.to_str, severity, caller(1), data, *flags)
				)
			end
		
			# See Log::debug
			# Uses @logger || $stderr as logging device.
			def debug(text, data=nil, *flags)
				(@logger || $stderr).puts(
					::SilverPlatter::Log::Entry.new(text.to_str, :debug, caller(1), data, *flags)
				)
			end
	
			# See Log::info
			# Uses @logger || $stderr as logging device.
			def info(text, data=nil, *flags)
				(@logger || $stderr).puts(
					::SilverPlatter::Log::Entry.new(text.to_str, :info, caller(1), data, *flags)
				)
			end
		
			# See Log::warn
			# Uses @logger || $stderr as logging device.
			def warn(text, data=nil, *flags)
				(@logger || $stderr).puts(
					::SilverPlatter::Log::Entry.new(text.to_str, :warn, caller(1), data, *flags)
				)
			end
		
			# See Log::error
			# Uses @logger || $stderr as logging device.
			def error(text, data=nil, *flags)
				(@logger || $stderr).puts(
					::SilverPlatter::Log::Entry.new(text.to_str, :error, caller(1), data, *flags)
				)
			end
		
			# See Log::fatal
			# Uses @logger || $stderr as logging device.
			def fatal(text, data=nil, *flags)
				(@logger || $stderr).puts(
					::SilverPlatter::Log::Entry.new(text.to_str, :fatal, caller(1), data, *flags)
				)
			end
	
			# See Log::log
			# Comfort#exception uses @logger || $stderr as logging device.
			# Comfort#exception will try to forward it to the logging device's
			# #exception method, if that can't be done it 
			def exception(e, data=nil, *flags)
				(@logger || $stderr).puts(
					if flags.first.is_a?(Time) then
						::SilverPlatter::Log::Entry.new(e.message, caller(1), [e, data], flags.shift, :exception, *flags)
					else
						::SilverPlatter::Log::Entry.new(e.message, caller(1), [e, data], :exception, *flags)
					end
				)
			end
		end # Comfort
	
		# enable Log.log etc.
		@logger = $stderr
		extend Comfort
	end # Log
end # SilverPlatter
