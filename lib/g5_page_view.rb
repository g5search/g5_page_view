require 'mongo'
require 'bson'

module G5PageView
  class << self
    attr_reader :connection, :db, :config

    def db
      @db ||= self.connection[self.config['database']]
    end

    def connect!(config={})
      @config ||= config
      options = config.inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo}
      nodes= options.delete(:nodes)
      raise "Invalid nodes specified" unless nodes && nodes.respond_to?(:<<)
      @connection= Mongo::ReplSetConnection.new(*(nodes << options))
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
