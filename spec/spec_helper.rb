require 'g5_page_view'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
    config.before :all do
      Seeds::SearchEngineSeed.execute
    end

	config.after :all do
    @@mongo.database('gts_test').collections.each{|coll| coll.remove unless coll.name =~ /system/ }	  
	end
end
