#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



require 'silverplatter/log/collector'
require 'silverplatter/log/comfort'
require 'silverplatter/log/consolelog'
require 'silverplatter/log/entry'
require 'silverplatter/log/essentials'
require 'silverplatter/log/filelog'
require 'silverplatter/log/nolog'



module SilverPlatter

	# == Synopsis
	#   Logfile = Log::File.new("foo.log")
	#   $stderr = Log::Forward(Logfile, :warn) # capture everything that prints to $stderr and treat it as :warn level message
	#   $stdout = Log::Forward(Logfile, :info)
	#   $stderr.puts "foo" # same as Log::File#log("foo", :warn)
	#   $stdout.puts "bar" # same as Log::File#log("bar", :info)
	#   begin
	#     raise "baz"
	#   rescue => exception
	#     $stdout.puts(exception) # same as Log::File#log(exception)
	#   end
	#
	# == Log Levels
	# debug:: Lowest level, used for messages that are irrelevant for daily use
	# info::  Informal log entries, like 'daemon started up'. Confirming that everything
	#         works as it should.
	# warn::  An possible problem occurred that might need fixing.
	# error:: An error occurred that requires fixing.
	# fail::  Irrecoverable error. The application will terminate after logging this event.
	#
	# == Use-cases
	# Daemon::      Since a daemon should not output anything at all, the advice is to create a
	#               logger (Log::File e.g.) and assign a Log::Forward to each, $stdout and $stderr.
	#               It's suggested to use :info as the default level for $stdout and :warn for
	#               $stderr.
	#
	# Application:: If you use Log with your application, you most likely want to log to a file.
	#               The advice for that is to simply assign a Log::File to $stderr, anything that
	#               prints to $stderr is now logged as :warn.
	#
	# Library::     With a library you most likely just want Log::Comfort. It adds logging methods
	#               and convenience methods to your class. It uses @logger if set, else $stderr to
	#               puts a Log::Entry. That way your library has decent logging even if the
	#               employing app doesn't use a logger.
	#
	# == Notes
	# require 'log/kernel' to get convenience methods in Kernel
	# it isn't required via 'log' alone to avoid accidental method name clashes.
	# notice that log/kernel will override Kernel#warn
	#
	module Log
	end
end
