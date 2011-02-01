module G5PageView
  class SearchEngine < ::Mongo::Collection
    def initialize(fields={})
      @fields= fields
      super(:search_engines, @@mongo.db('gts_test'))
    end
    
    def required_fields
      [:search_engine, :source_host, :keyword_param, :campaign_rule]
    end
    
    # key :source_host
    def save
      required_fields.each{|r| raise Exception unless @fields[r] }
      super(@fields)
    end
  end
end

