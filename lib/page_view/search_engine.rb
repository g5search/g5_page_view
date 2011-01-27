module G5PageView
  class SearchEngine
    include Mongoid::Document
    self.collection_name = "search_engines"

    field :search_engine
    field :source_host
    field :keyword_param
    field :campaign_rule

    key :source_host
  end
end
