$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib/page_view'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'g5_page_view'
require 'search_engine'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
	config.after :all do
		Mongoid.master.collections.select {|c| c.name !~ /system/ }.each(&:drop)
	end
end
