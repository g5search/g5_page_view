require 'uri'

module G5PageView
  class PageView < ::Hash
    include Validations
    extend Finders
    
    attr_accessor :referring_domain, :domain

    def self.collection
      G5PageView::db['page_views']  
    end 

    def required_fields 
      [:url, :session_id]
    end

    def save!
      validate_required!
      self.created_at = Time.now unless self[:created_at]
      attribute_traffic!
      self.class.collection.insert(self)
    end

    def created_at=(time)
      self[:created_at]= time
      self[:sequence]= self[:created_at].to_f
    end

    def referring_domain
      @referring_domain ||= parse_domain(self[:referring_url]) 
    end

    def domain
      @domain ||= parse_domain(self[:url]) 
    end

    def parse_domain(url)
      URI.parse(url).host rescue nil
    end

    private
    def attribute_traffic!
      TrafficAttributionFactory.new.update!(self)
    end
  end
end

