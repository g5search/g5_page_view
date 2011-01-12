module Seeds
  class SearchEngineSeed
    class << self
      def execute
        G5PageView::SearchEngine.new(:search_engine => "bing", :source_host => "www.bing.com", :keyword_param => "q", :campaign_rule=>'b').upsert
        G5PageView::SearchEngine.new(:search_engine => "google", :source_host => "www.google.com", :keyword_param => "q", :campaign_rule=>'g').upsert
        G5PageView::SearchEngine.new(:search_engine => "google maps", :source_host => "maps.google.com", :keyword_param => "dq").upsert
        G5PageView::SearchEngine.new(:search_engine => "images google", :source_host => "images.google.com", :keyword_param => "q").upsert
        G5PageView::SearchEngine.new(:search_engine => "yahoo", :source_host => "search.yahoo.com", :keyword_param => "p", :campaign_rule=>'y').upsert
        G5PageView::SearchEngine.new(:search_engine => "aol", :source_host => "search.aol.com", :keyword_param => "query").upsert
        G5PageView::SearchEngine.new(:search_engine => "msn", :source_host => "search.msn.com", :keyword_param => "q").upsert
        G5PageView::SearchEngine.new(:search_engine => "comcast", :source_host => "search.comcast.net", :keyword_param => "query").upsert
        G5PageView::SearchEngine.new(:search_engine => "superpages",  :source_host => "www.superpages.com").upsert
        G5PageView::SearchEngine.new(:search_engine => "localsearch", :source_host => "www.localsearch.com").upsert
        G5PageView::SearchEngine.new(:search_engine => 'facebook',    :source_host => 'www.facebook.com', :keyword_param=>'q', :campaign_rule=>'fb').upsert
        G5PageView::SearchEngine.new(:search_engine => 'self storage finders',    :source_host => 'www.selfstoragefinders.com', :keyword_param=>'q', :campaign_rule=>'ssfd').upsert
        G5PageView::SearchEngine.new(:search_engine => 'self storage',    :source_host => 'www.selfstorage.com', :campaign_rule=>'ss').upsert
        G5PageView::SearchEngine.new(:search_engine => 'us storage',    :source_host => 'www.usstorage.com', :campaign_rule=>'uss').upsert    
        G5PageView::SearchEngine.new(:search_engine => 'i need storage', :source_host => 'www.ineedstorage.com', :campaign_rule=>'ins').upsert    
      end
  
      def undo
        G5PageView::SearchEngine.destroy_all
      end
    end
  end
end
