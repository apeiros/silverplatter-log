#--
# Copyright 2007-2008 by Stefan Rusterholz.
# All rights reserved.
# See LICENSE.txt for permissions.
#++



module SilverPlatter
	module Log
		# Filter implements a chainable filter, which means you can add multiple filters and
		# pass it as one.
		# To be used in conjunction e.g. with Log::FileReader
		class Filter

			# The filters ready for you to filter out log entries of interest
			Filters = {
				:match_text       => proc { |entry, pattern|    entry.text =~ pattern           },
				:match_text_not   => proc { |entry, pattern|    entry.text !~ pattern           },
				:include_text     => proc { |entry, substring|  entry.text.include?(substring)  },
				:include_text_not => proc { |entry, substring| !entry.text.include?(substring)  },
				:from_date        => proc { |entry, mintime|    entry.time > mintime            },
				:until_date       => proc { |entry, maxtime|    entry.time < maxtime            },
				:within           => proc { |entry, min, max|   entry.time.between?(min, max)   },
				:one_of_levels    => proc { |entry, levels|     levels.include?(entry.severity) },
				:none_of_levels   => proc { |entry, levels|    !levels.include?(entry.severity) },
				:with_flag        => proc { |entry, flag|       entry.flags.include?(flag)      },
				:without_flag     => proc { |entry, flag|      !entry.flags.include?(flag)      },
				:with_flags       => proc { |entry, flags|      (flags-entry.flags).empty?      },
				:without_flags    => proc { |entry, flags|     !(flags&entry.flags).empty?      },
			}
			
			# Add a filter.
			#   Log::Filter.add(:exception) { |entry| entry.flags.include?('exception') }
			def self.add(name, &filter)
				self[name] = filter
			end
			
			# Returns a filter with arguments
			def self.[](name, *args)
				proc { |entry| Filters[name].call(entry, *args) }
			end
			
			# Create a new Filter instance. See Log::Filter for more information.
			def initialize(filters=nil)
				@filters = filters || {}
			end
			
			# Match an entry against all filters.
			def call(entry)
				@filters.all? { |name, args|
					Filters[name].call(entry, *args)
				}
			end
			
			def +(other)
				Filter.new(@filters.merge(other.filters))
			end
		end
	end
end
