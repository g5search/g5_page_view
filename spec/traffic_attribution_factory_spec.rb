require "spec_helper"

describe G5PageView::TrafficAttributionFactory do

  before(:each) do
    @traffic = G5PageView::TrafficAttributionFactory.new
  end

  describe "Sources" do
    before(:each) do
      @cpm='glsda1'
      @page_view= G5PageView::PageView[
        :url, 'http://storquest.com',
        :referring_url,'http://google.com?cpm='+@cpm,
        :cpm,@cpm
      ]
      @traffic.stub!(:set_channel)
    end

    context "with a campaign (cpm)" do
      it "retrieves the source from the cpm" do
        G5PageView::Campaign.should_receive(:parse).with(@page_view[:cpm]).and_return('google.com')
        @traffic.update!(@page_view)
        @page_view[:source].should eql('google.com')
      end
    end

    context "With a referring domain" do
      before(:each) do
        @page_view[:cpm]=''
        @engine= G5PageView::SearchEngine[:source_host, 'bing.com']
      end
      it "retrieves the search engine as the source when the request originated from a known search engine" do
        @traffic.should_receive(:search_engine).exactly(2).times.and_return(@engine)
        @traffic.update!(@page_view)
        @page_view[:source].should eql('bing.com')        
      end
      it "retrieves the referring domain for the source" do
        @page_view[:cpm]= nil
        @traffic.stub!(:search_engine).and_return(nil)
        @traffic.update!(@page_view)
        @page_view[:source].should eql(@page_view.referring_domain)                
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
      @traffic.stub!(:set_source)
      @page_view= G5PageView::PageView[
        :url,'http://storquest.com',
        :referring_url,'http://google.com'
      ]
      @paid= G5PageView::AVAILABLE_CHANNELS.fetch('paid')
      @organic= G5PageView::AVAILABLE_CHANNELS.fetch('organic')
      @direct= G5PageView::AVAILABLE_CHANNELS.fetch('direct')
      @referral= G5PageView::AVAILABLE_CHANNELS.fetch('referral')
    end

    context 'Checks in succession' do
      it "should check for the channel in order of precedence" do
        @traffic.checks.should eql([:paid?, :direct?, :organic?, :referral?])
      end

      it "should set the channel to the first check that is met" do
        @traffic.should_receive(:paid?).and_return(nil)
        @traffic.should_receive(:direct?).and_return(@direct)
        @traffic.should_receive(:organic?).never
        @traffic.set_channel(@page_view)
        @page_view[:channel].should eql(@direct)
      end
    end

    context 'A paid channel' do
      before(:each) do
        @page_view[:cpm]= 'gls1921'
      end
      it 'has a campaign code' do
        @traffic.update!(@page_view)
        @page_view[:channel].should eql(@paid)
      end

      it 'has a campaign code that isn\'t empty' do
        @page_view[:cpm]=''
        @traffic.update!(@page_view)
        @page_view[:channel].should_not eql(@paid)
      end
    end

    describe 'An organic channel' do
      before(:each) do
        G5PageView::SearchEngine.first(:source_host=>'maps.google.com')
        @page_view[:cpm]=nil
        @traffic.update!(@page_view)
      end

      it 'has a referring domain that is a known search engine' do
        @page_view.referring_domain=nil
        @page_view[:referring_url]= 'http://maps.google.com'        
        @traffic.update!(@page_view)
        @page_view[:channel].should eql(@organic)
      end
    end

    context 'A direct channel' do
      it 'has no referring url' do
        @page_view[:referring_url]= nil
        @traffic.update!(@page_view)
        @page_view[:channel].should eql(@direct)
      end
      it "has an empty referring url" do
        @page_view[:referring_url]= ''
        @traffic.update!(@page_view)
        @page_view[:channel].should eql(@direct)
      end
    end

    context 'A referral' do
      it 'has a referring domain that\'s different than the current, referring domain not a search engine' do
        @page_view[:referring_url]= 'http://www.storquest-finders.com'
        @page_view[:url] = 'http://storquest.com'
        @traffic.update!(@page_view)
        @page_view[:channel].should eql(@referral)
      end
    end

    context 'No channel' do
      it 'has a domain equivalent to that of the last page view for that session' do
        @page_view[:referring_url]= 'http://storquest.com'
        @page_view[:url]= 'http://storquest.com'
        @page_view[:channel].should be_nil
      end
    end

    context 'search engine lookup' do
      it 'will look up search engine for a known engine' do
        @traffic.search_engine = nil
        se = G5PageView::SearchEngine[:search_engine, 'storeme', :source_host, 'searchme', :campaign_rule, 'ins', :keyword_param, 's']   
        se.save!
        @traffic.search_engine("searchme").should_not be_nil
        G5PageView::SearchEngine.should_not_receive(:first)
        @traffic.search_engine("searchme").should_not be_nil
      end
    end
  end
end
