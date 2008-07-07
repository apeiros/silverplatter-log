require File.dirname(__FILE__)+'/../../../bacon_helper'
require 'silverplatter/log/formatter'

include SilverPlatter::Log
FakeEntry = Struct.new(:text, :severity, :origin, :time, :data)

describe 'Creating a Formatter' do
	it 'should raise without arguments and block' do
		proc {
			Formatter.new
		}.should.raise(ArgumentError)
	end
	
	it 'should accept a hash as argument' do
		proc {
			Formatter.new(:foo => proc {})
		}.should.not.raise
	end

	it 'should accept a block' do
		proc {
			Formatter.new() {}
		}.should.not.raise
	end
end

describe 'Formatter with only a generic block' do
	before do
		@entry_debug = FakeEntry.new("test", :debug)
		@entry_info  = FakeEntry.new("test", :info)
		@entry_warn  = FakeEntry.new("test", :warn)
		@entry_error = FakeEntry.new("test", :error)
		@entry_fatal = FakeEntry.new("test", :fatal)
		@formatter1  = Formatter.new { |e| "formatted #{e.severity} #{e.text}" }
		@formatter2  = Formatter.new { |e| "formatted #{e.text}" }
	end
	
	it 'should format using the generic format' do
		@formatter1.format(@entry_debug).should.be == "formatted debug test"
		@formatter1.format(@entry_info).should.be  == "formatted info test"
		@formatter1.format(@entry_warn).should.be  == "formatted warn test"
		@formatter1.format(@entry_error).should.be == "formatted error test"
		@formatter1.format(@entry_fatal).should.be == "formatted fatal test"
	end
	
	it 'should format all the same' do
		@formatter2.format(@entry_debug).should.be == @formatter2.format(@entry_info)
		@formatter2.format(@entry_info).should.be == @formatter2.format(@entry_warn)
		@formatter2.format(@entry_warn).should.be == @formatter2.format(@entry_error)
		@formatter2.format(@entry_error).should.be == @formatter2.format(@entry_fatal)
	end
end

describe 'Formatter with a hash' do
	before do
		@entry_debug = FakeEntry.new("test", :debug)
		@entry_info  = FakeEntry.new("test", :info)
		@entry_warn  = FakeEntry.new("test", :warn)
		@entry_error = FakeEntry.new("test", :error)
		@entry_fatal = FakeEntry.new("test", :fatal)
		@formatter  = Formatter.new(
			:debug => proc { "formatted debug" },
			:info  => proc { "formatted info" },
			:warn  => proc { "formatted warn" },
			:error => proc { "formatted error" },
			:fatal => proc { "formatted fatal" }
		)
	end
	
	it 'should format each with the formatter for it' do
		@formatter.format(@entry_debug).should.be == "formatted debug"
		@formatter.format(@entry_info).should.be  == "formatted info"
		@formatter.format(@entry_warn).should.be  == "formatted warn"
		@formatter.format(@entry_error).should.be == "formatted error"
		@formatter.format(@entry_fatal).should.be == "formatted fatal"
	end
end

describe 'Formatter with a hash and a block' do
	before do
		@entry_debug = FakeEntry.new("test", :debug)
		@entry_info  = FakeEntry.new("test", :info)
		@entry_warn  = FakeEntry.new("test", :warn)
		@entry_error = FakeEntry.new("test", :error)
		@entry_fatal = FakeEntry.new("test", :fatal)
		@formatter  = Formatter.new(
			:debug => proc { "formatted debug" },
			:warn  => proc { "formatted warn" },
			:fatal => proc { "formatted fatal" }
		) { "formatted generic" }
	end
	
	it 'should format each with the formatter for it' do
		@formatter.format(@entry_debug).should.be == "formatted debug"
		@formatter.format(@entry_info).should.be  == "formatted generic"
		@formatter.format(@entry_warn).should.be  == "formatted warn"
		@formatter.format(@entry_error).should.be == "formatted generic"
		@formatter.format(@entry_fatal).should.be == "formatted fatal"
	end
end
