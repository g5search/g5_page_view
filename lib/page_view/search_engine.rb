module G5PageView
  class SearchEngine < ::Hash
    include Validations
    extend Finders
    
    def self.collection
      G5PageView::db['search_engines']  
    end    
    
    def required_fields 
      [:search_engine, :source_host, :keyword_param, :campaign_rule]
    end
    
    def save!
      validate_required!
      self.class.collection.insert(self)
    end
  end
end


