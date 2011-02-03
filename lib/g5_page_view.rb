require 'mongo'
require 'bson'

require 'ruby-debug'

module G5PageView
  class << self
    attr_reader :connection, :db, :config

    def connect!(config={})
      options = Marshal.load(Marshal.dump(config.inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo}))      
      nodes= options.delete(:nodes)
      raise "Invalid nodes specified" unless nodes && nodes.respond_to?(:<<)
      @connection= Mongo::ReplSetConnection.new(*(nodes << options))
      configure!(config)
    end
    
    def configure!(config={})
      @config = config
      raise 'No database specified' unless @config.has_key?('database')
      @db = @connection[@config['database']] 
    end
  end
end

$LOAD_PATH.unshift(File.dirname(__FILE__))

#Load seed data
Dir["#{File.dirname(__FILE__)}/seeds/**/*.rb"].each {|f| require f}

#Load custom exception classes
require 'exceptions/exception'

require 'page_view/search_engine'
require 'page_view/campaign'
require 'page_view/page_view'
require 'page_view/traffic_attribution_factory'
