module Seeds
  class SearchEngineSeed
    class << self
      def execute
        SearchEngine.new(:search_engine => "bing", :source_host => "www.bing.com", :keyword_param => "q", :campaign_rule=>'b').upsert
        SearchEngine.new(:search_engine => "google", :source_host => "www.google.com", :keyword_param => "q", :campaign_rule=>'g').upsert
        SearchEngine.new(:search_engine => "google maps", :source_host => "maps.google.com", :keyword_param => "dq").upsert
        SearchEngine.new(:search_engine => "images google", :source_host => "images.google.com", :keyword_param => "q").upsert
        SearchEngine.new(:search_engine => "yahoo", :source_host => "search.yahoo.com", :keyword_param => "p", :campaign_rule=>'y').upsert
        SearchEngine.new(:search_engine => "aol", :source_host => "search.aol.com", :keyword_param => "query").upsert
        SearchEngine.new(:search_engine => "msn", :source_host => "search.msn.com", :keyword_param => "q").upsert
        SearchEngine.new(:search_engine => "comcast", :source_host => "search.comcast.net", :keyword_param => "query").upsert

        SearchEngine.new(:search_engine => "superpages",  :source_host => "www.superpages.com").upsert
        SearchEngine.new(:search_engine => "localsearch", :source_host => "www.localsearch.com").upsert
        SearchEngine.new(:search_engine => 'facebook',    :source_host => 'www.facebook.com', :keyword_param=>'q', :campaign_rule=>'fb').upsert
        SearchEngine.new(:search_engine => 'self storage finders',    :source_host => 'www.selfstoragefinders.com', :keyword_param=>'q', :campaign_rule=>'ssfd').upsert
        SearchEngine.new(:search_engine => 'self storage',    :source_host => 'www.selfstorage.com', :campaign_rule=>'ss').upsert
        SearchEngine.new(:search_engine => 'us storage',    :source_host => 'www.usstorage.com', :campaign_rule=>'uss').upsert    
        SearchEngine.new(:search_engine => 'i need storage', :source_host => 'www.ineedstorage.com', :campaign_rule=>'ins').upsert    
      end
  
      def undo
        SearchEngine.destroy_all
      end
    end
  end
end