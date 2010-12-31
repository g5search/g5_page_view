class SearchEngine
  include Mongoid::Document

  field :search_engine
  field :source_host
  field :keyword_param
  field :campaign_rule

  key :source_host

end
