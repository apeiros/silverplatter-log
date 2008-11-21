require File.dirname(__FILE__)+'/../../../bacon_helper'
require 'silverplatter/log/entry'

include SilverPlatter::Log

describe 'Creating an Entry' do
	it 'should raise without arguments' do
		proc {
			Entry.new
		}.should.raise(ArgumentError)
	end
	
	it 'can be instanciated with a single argument, the message' do
		proc {
			Entry.new('message')
		}.should.not.raise
	end

	it 'can be instanciated with the message and severity' do
		proc {
			Entry.new('message')
		}.should.not.raise
	end
end

describe 'A created Entry' do
	before do
		@entry1 = Entry.new('message', :info, %w'origin', [:data, :stuff], :flag1, :flag2)
	end

	it 'should allow access to the message' do
		@entry1.text.should.be == "message"
		@entry1.severity.should.be == :info
		@entry1.origin.should.be == %w'origin'
		@entry1.data.should.be == [:data, :stuff]
		@entry1.flags.keys.should(equal_unordered(["flag1", "flag2"]))
		@entry1.flags.values.should.be == [true, true] # all are true, order doesn't matter
	end
	
	it 'should be eql? to itself' do
		@entry1.should.be.eql @entry1
	end
end

describe 'A serialized Entry' do
	before do
		@entry = Entry.new('message', :info, %w'origin', [:data, :stuff], :flag1, :flag2)
		@deser = Entry.deserialize(@entry.serialize)
	end
	
	it 'should be creatable' do
		proc { @entry.serialize }.should.not.raise
	end
	
	it 'should be deserializable' do
		@deser.should.be.eql(@entry)
		@deser.data.should.be == [:data, :stuff]
	end
end
