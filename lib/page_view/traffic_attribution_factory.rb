AVAILABLE_CHANNELS= {
  'paid'     =>1, 
  'direct'   =>2, 
  'organic'  =>3,
  'referral' =>4
}

class TrafficAttributionFactory

  attr_accessor :search_engine

  def update!(page_view)
    set_channel(page_view)
    set_source(page_view)
  end

  def set_source(page_view)
    page_view.source= if present?(page_view.cpm)
                        Campaign.parse(page_view.cpm)
                      elsif self.search_engine(page_view.referring_domain)
                        self.search_engine.source_host
                      else
                        page_view.referring_domain
                      end
  end

  def checks
    [:paid?, :direct?, :organic?, :referral?]
  end

  def set_channel(page_view)      
    channel=nil
    checks.each do |method|
      channel= self.send(method, page_view)
      break if channel
    end
    page_view.channel= channel
  end

  def paid?(page_view)
    present?(page_view.cpm){ AVAILABLE_CHANNELS.fetch('paid') }
  end

  def direct?(page_view)
    AVAILABLE_CHANNELS.fetch('direct') if page_view.referring_domain.nil? || page_view.referring_domain.empty?
  end

  def organic?(page_view)
    if present?(page_view.referring_domain) && self.search_engine(page_view.referring_domain)
      AVAILABLE_CHANNELS.fetch('organic')
    end
  end

  def search_engine(referring_domain='')
    return @search_engine if ( @search_engine && @search_engine.source_host == referring_domain )
    @search_engine = SearchEngine.find(:first, :conditions=>{:source_host=>referring_domain}) 
  end

  def referral?(page_view)
    AVAILABLE_CHANNELS.fetch('referral') if page_view.domain != page_view.referring_domain
  end

  def present?(property, &block)
    result= property && !property.empty?
    return result unless block_given?
    yield if result
  end
end
