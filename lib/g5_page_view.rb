require 'mongo'
require 'bson'

@@mongo= Mongo::ReplSetConnection.new(['localhost', 27017])

#Load seed data
Dir["#{File.dirname(__FILE__)}/seeds/**/*.rb"].each {|f| require f}

require 'page_view/search_engine'
require 'page_view/campaign'
require 'page_view/page_view'
require 'page_view/traffic_attribution_factory'


