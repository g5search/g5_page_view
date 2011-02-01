module Seeds
  class SearchEngineSeed
    class << self
      def execute
        search_engines=[
            {:search_engine => "bing",                :source_host => "www.bing.com",               :keyword_param => "q",  :campaign_rule=>'b'},
            {:search_engine => "google",              :source_host => "www.google.com",             :keyword_param => "q",  :campaign_rule=>'g'},
            {:search_engine => "google maps",         :source_host => "maps.google.com",            :keyword_param => "dq"},
            {:search_engine => "images google",       :source_host => "images.google.com",          :keyword_param => "q"},
            {:search_engine => "yahoo",               :source_host => "search.yahoo.com",           :keyword_param => "p",  :campaign_rule=>'y'},
            {:search_engine => "aol",                 :source_host => "search.aol.com",             :keyword_param => "query"},
            {:search_engine => "msn",                 :source_host => "search.msn.com",             :keyword_param => "q"},
            {:search_engine => "comcast",             :source_host => "search.comcast.net",         :keyword_param => "query"},
            {:search_engine => "superpages",          :source_host => "www.superpages.com"},
            {:search_engine => "localsearch",         :source_host => "www.localsearch.com"},
            {:search_engine => 'facebook',            :source_host => 'www.facebook.com',           :keyword_param=>'q',    :campaign_rule=>'fb'},
            {:search_engine => 'self storage finders',:source_host => 'www.selfstoragefinders.com', :keyword_param=>'q',    :campaign_rule=>'ssfd'},
            {:search_engine => 'self storage',        :source_host => 'www.selfstorage.com',                                :campaign_rule=>'ss'},
            {:search_engine => 'us storage',          :source_host => 'www.usstorage.com',                                  :campaign_rule=>'uss'},
            {:search_engine => 'i need storage',      :source_host => 'www.ineedstorage.com',                               :campaign_rule=>'ins'}
          ]
        
        search_engines.each do |se| 
          @@mongo.db('gts_production').collection('search_engines').update(se, se, :upsert=>true)
        end
      end
  
      def undo
        @@mongo.db('gts_production').collection('search_engines').remove({})
      end
    end
  end
end
