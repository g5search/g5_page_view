module G5PageView
  class SearchEngine < ::Hash
    def collection
      @collection ||= G5PageView.connection.db('gts_test')['search_engines']  
    end
    
    def required_fields 
      [:search_engine, :source_host, :keyword_param, :campaign_rule]
    end
    
    def save!
      required_fields.each do |r| 
        unless (self[r] || self[r.to_s])
          raise Exceptions::MissingFields.new(required_fields, self.to_s) 
        end
      end
      self.collection.insert(self)
    end
  end
end


