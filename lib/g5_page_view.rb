$LOAD_PATH.unshift(File.dirname(__FILE__))

module G5PageView

  class << self

    def configure
      require 'mongoid'
      config = Mongoid::Config.instance
      block_given? ? yield(config) : config
      Dir["#{File.dirname(__FILE__)}/page_view/*.rb"].each {|f| require f}

      # require 'page_view/page_view'
      # require 'page_view/search_engine'
      # require 'page_view/campaign'
      # require 'page_view/traffic_attribution_factory'
    end

    alias :config :configure
  end

  Mongoid::Config.public_instance_methods(false).each do |name|
    (class << self; self; end).class_eval <<-EOT
      def #{name}(*args)
        configure.send("#{name}", *args)
      end
    EOT
  end
end

