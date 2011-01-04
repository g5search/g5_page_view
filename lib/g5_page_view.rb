$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'mongoid'
require 'page_view/page_view'
require 'page_view/search_engine'
require 'page_view/campaign'
require 'page_view/traffic_attribution_factory'

module G5PageView

  def configure
    config = Mongoid::Config.instance
    block_given ? yield(config) : config
  end

  alias :config :configure

  Mongoid::Config.public_instance_methods(false).each do |name|
    (class << self; self; end).class_eval <<-EOT
      def #{name}(*args)
        configure.send("#{name}", *args)
      end
    EOT
  end

end

