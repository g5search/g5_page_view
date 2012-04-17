require 'mongo'
require 'bson'

module G5PageView
  class << self
    attr_reader :connection, :db, :config

    def symbolize(config={})
      return config.inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo}
    end
    
    def reconnect!
      connect!(config)
    end

    def connect!(config={})
      config= symbolize(config)
      options = Marshal.load(Marshal.dump(config))      
      nodes= options.delete(:nodes)
      db= options.delete(:database)
      raise "Invalid nodes specified" unless nodes && nodes.respond_to?(:<<)
      @connection = mongo_connect(nodes, options)
      @db = @connection.db(db)
      @config = config
    end

    def mongo_connect(nodes, options)
      begin
        connection = Mongo::ReplSetConnection.new(nodes, options)
      rescue Mongo::ConnectionFailure => e
        hostport = nodes[0].split(":")
        connection= Mongo::Connection.new(hostport[0], hostport[1])
      end
      connection
    end
  end
end

$LOAD_PATH.unshift(File.dirname(__FILE__))

#Load seed data
Dir["#{File.dirname(__FILE__)}/seeds/**/*.rb"].each {|f| require f}

#Load custom exception classes
require 'exceptions/exception'

#Mongo Driver helpers
require 'page_view/validations'
require 'page_view/finders'

require 'page_view/search_engine'
require 'page_view/campaign'
require 'page_view/page_view'
require 'page_view/traffic_attribution_factory'
