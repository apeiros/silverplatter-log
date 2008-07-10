#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module SilverPlatter
	module Log

		# == Summary
		# Log::Reader provides facilities to read and filter logfiles in the standard serialized
		# format.
		# 
		# == Synopsis
		#   require 'silverplatter/log/filereader'
		#   reader = SilverPlatter::Log::FileReader.new('my.log')
		#   reader.filter_by
		#
		class FileReader

			include Enumerable

			# Define a filter. The first argument it gets is the entry, all others are the arguments
			# as passed in to filter down
			def self.def_filter(name, &filter)
				Filters[name] = filter
			end

			# create a new Log::FileReader, opening the file specified by the path argument.
			def initialize(path, filters=nil)
				@file    = ::File.open(path, "rb")
				@pos     = 0
				@filters = filters
			end

			# === Summary
			# Only show matching entries.
			#
			# === Synopsis
			#   reader 
			#
			# === Description
			# you can either filter by a name or using a block. By a name it will use the stored
			# filter with the given name from Log::FileReader::Filters
			#
			def filter_by(*args, &filter)
				filter = Filters[args.shift] unless filter
				raise ArgumentError, "Unknown Filter #{name} and no block given" unless filter
				@filters << [filter, args]
			end
			
			# Remove all applied filters.
			def clear_filters
				@filters.clear
			end

			# Test whether a given entry matches the current filtering.
			def matches(entry)
				@filters.all? { |filter| filter.call(entry) }
			end		
			
			# Read the first N entries that match the filtering.
			def head(n)
				i = 0
				while line = @file.gets and i < n
					@pos += 1
					entry = Log::Entry.deserialize(line)
					if matches(entry) then
						yield(entry)
						i+=1
					end
				end
				entries
			end
	
			# Read the last N entries that match the filtering.
			# TODO: do a tailread.
			def tail(n, &block)
				entries = []
				while line = @file.gets and entries.length < n
					@pos += 1
					entry = Log::Entry.deserialize(line)
					entries.push entry if matches(entry)
				end
				while line = @file.gets
					@pos += 1
					entry = Log::Entry.deserialize(line)
					entries.push entry if matches(entry)
					entries.shift
				end
				entries.compact
				entries.each(&block)
			end
			
			def each
				while line = @file.gets
					@pos += 1
					entry = Log::Entry.deserialize(line)
					yield(entry) if matches(entry)
				end
			end
		end
	end
end
