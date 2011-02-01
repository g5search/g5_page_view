module G5PageView
  class PageView
    attr_accessor :referring_domain

    # self.collection_name = "page_views"
    # 
    # field :client_id
    # field :store_id
    # field :session_id
    # field :visitor_cookie
    # field :url
    # field :ip
    # field :locale
    # field :http_agent
    # field :cpm
    # field :coupon_code
    # field :conversion_type
    # field :document_group
    # field :referring_url
    # #Fields for attributing traffic
    # field :source
    # field :channel,         :type => Integer
    # field :campaign
    # field :created_at,      :type => Time
    # field :sequence,        :type => Float
    # 
    # index :client_id
    # 
    # index([
    #       [:store_id, Mongo::ASCENDING],
    #       [:visitor_cookie, Mongo::ASCENDING]
    # ])
    # 
    # index([
    #       [:created_at, Mongo::ASCENDING],
    #       [:session_id, Mongo::ASCENDING]
    # ])
    # 
    # validates_presence_of :url
    # validates_presence_of :session_id
    # 
    # before_save :set_save_time, :attribute_traffic
    # 
    # def created_at=(time)
    #   @created_at= time
    #   self.write_attribute(:created_at, @created_at)
    #   self.sequence= @created_at.to_f
    # end
    # 
    # def referring_domain
    #   @referring_domain ||= parse_domain(self.referring_url) 
    # end
    # def domain
    #   @domain ||= parse_domain(self.url) 
    # end
    # def parse_domain(url)
    #   URI.parse(url).host rescue nil
    # end
    # 
    # private
    # def attribute_traffic
    #   TrafficAttributionFactory.new.update!(self)
    # end
    # 
    # def set_save_time
    #   self.created_at = Time.now unless self.created_at
    # end
  end
end

