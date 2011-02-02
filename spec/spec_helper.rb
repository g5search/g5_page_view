require 'g5_page_view'
require 'yaml'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

config= YAML::load(File.new(File.dirname(__FILE__)+'/config.yml'))
G5PageView::connect!(config['test'])

RSpec.configure do |config|
    config.before :all do
      Seeds::SearchEngineSeed.execute
    end

	config.after :all do
    G5PageView.connection.db('gts_test').collections.each{|coll| coll.remove unless coll.name =~ /system/ }	  
	end
end
