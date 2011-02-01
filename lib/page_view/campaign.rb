module G5PageView
  class Campaign
    def self.parse(cpm)
      host=nil
      self.engines.reject{|e| e.campaign_rule.nil? }.each do |engine|
        if cpm =~ /^#{engine.campaign_rule}/
          host= engine.source_host
          break
        end
      end
      return host
    end

    def self.engines
      @engines ||= @@mongodb.db('gts_production')['search_engines'].find({:fields=>[:source_host, :campaign_rule]}).collect{|s| s}
    end
  end
end
