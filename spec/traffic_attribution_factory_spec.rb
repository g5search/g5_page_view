require "spec_helper"

describe TrafficAttributionFactory do
  describe "Sources" do
    before(:each) do
      @cpm='glsda1'
      @page_view= PageView.new(
        :url=>'http://storquest.com',
        :referring_url=>'http://google.com?cpm='+@cpm,
        :cpm=>@cpm
      )
      TrafficAttributionFactory.stub!(:set_channel)
    end
    
    context "with a campaign (cpm)" do
      it "retrieves the source from the cpm" do
        Campaign.should_receive(:parse).with(@page_view.cpm).and_return('google.com')
        TrafficAttributionFactory.update!(@page_view)
        @page_view.source.should eql('google.com')
      end
    end
    
    context "With a referring domain" do
      before(:each) do
        @page_view.cpm=''
        @engine= SearchEngine.new(:source_host=>'bing.com')
      end
      it "retrieves the search engine as the source when the request originated from a known search engine" do
        TrafficAttributionFactory.should_receive(:search_engine).times(2).and_return(@engine)
        TrafficAttributionFactory.update!(@page_view)
        @page_view.source.should eql('bing.com')        
      end
      it "retrieves the referring domain for the source" do
        @page_view.stub!(:cpm).and_return(nil)
        TrafficAttributionFactory.stub!(:search_engine).and_return(nil)
        TrafficAttributionFactory.update!(@page_view)
        @page_view.source.should eql(@page_view.referring_domain)                
      end
    end
  end
  
  describe "Keywords" do
    context "With a known search engine" do
      it "parses the value of the keyword parameter from the referring url"
    end
    
    context "Without a known search engine" do
      it "has no keywords associated with the request"
    end
  end
  
  describe "Channels" do
    before(:each) do
      TrafficAttributionFactory.stub!(:set_source)
      @page_view= PageView.new(
        :url=>'http://storquest.com',
        :referring_url=>'http://google.com'
      )
      @paid= AVAILABLE_CHANNELS.fetch('paid')
      @organic= AVAILABLE_CHANNELS.fetch('organic')
      @direct= AVAILABLE_CHANNELS.fetch('direct')
      @referral= AVAILABLE_CHANNELS.fetch('referral')
     end
    
    context 'Checks in succession' do
      it "should check for the channel in order of precedence" do
        TrafficAttributionFactory.checks.should eql([
            :paid?, :direct?, :organic?, :referral?
          ])
      end
      
      it "should set the channel to the first check that is met" do
        TrafficAttributionFactory.should_receive(:paid?).and_return(nil)
        TrafficAttributionFactory.should_receive(:direct?).and_return(@direct)
        TrafficAttributionFactory.should_receive(:organic?).never
        TrafficAttributionFactory.set_channel(@page_view)
        @page_view.channel.should eql(@direct)
      end
    end
    
    context 'A paid channel' do
      before(:each) do
        @page_view.cpm= 'gls1921'
      end
      it 'has a campaign code' do
        TrafficAttributionFactory.update!(@page_view)
        @page_view.channel.should eql(@paid)
      end
      
      it 'has a campaign code that isn\'t empty' do
        @page_view.cpm=''
        TrafficAttributionFactory.update!(@page_view)
        @page_view.channel.should_not eql(@paid)
      end
    end

    describe 'An organic channel' do
      before(:each) do
        SearchEngine.find_or_create_by(:source_host=>'maps.google.com')
        @page_view.cpm=nil
        TrafficAttributionFactory.update!(@page_view)
      end

      it 'has a referring domain that is a known search engine' do
        @page_view.referring_domain=nil
        @page_view.referring_url= 'http://maps.google.com'        
        TrafficAttributionFactory.update!(@page_view)
        @page_view.channel.should eql(@organic)
      end
    end

    context 'A direct channel' do
      it 'has no referring url' do
        @page_view.referring_url= nil
        TrafficAttributionFactory.update!(@page_view)
        @page_view.channel.should eql(@direct)
      end
      it "has an empty referring url" do
        @page_view.referring_url= ''
        TrafficAttributionFactory.update!(@page_view)
        @page_view.channel.should eql(@direct)
      end
    end
    
    context 'A referral' do
      it 'has a referring domain that\'s different than the current' do
        @page_view.referring_url= 'http://storquest-affiliate.com'
        @page_view.url = 'http://storquest.com'
        TrafficAttributionFactory.update!(@page_view)
        @page_view.channel.should eql(@referral)
      end
    end

    context 'No channel' do
      it 'has a domain equivalent to that of the last page view for that session' do
        @page_view.referring_url= 'http://storquest.com'
        @page_view.url= 'http://storquest.com'
        @page_view.channel.should be_nil
      end
    end
  end
end
