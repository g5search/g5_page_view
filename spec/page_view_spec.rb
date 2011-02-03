require "spec_helper"

describe G5PageView::PageView do
  before do
    @pv = G5PageView::PageView[:visitor_cookie, "acookie", :url, "http://someurl.com", :session_id, "123"]
  end

  it "should parse the domain for the request" do
    @pv.domain.should eql('someurl.com')
  end
  
  it "should parse the domain for the previous request" do
    @pv[:referring_url]='http://www.google.com'
    @pv.referring_domain.should eql('www.google.com')
  end
  
  it "should be nil if the domain is unparsable" do
    @pv.parse_domain('a bad uri').should be_nil
  end

  context 'Attributing traffic to source,channel,campaign' do
    it "should attribute the traffic before saving" do
      traffic = G5PageView::TrafficAttributionFactory.new
      G5PageView::TrafficAttributionFactory.stub!(:new).and_return(traffic)
      traffic.should_receive(:update!).with(@pv)
      @pv.save!
    end
  end

  context "date & time split" do
    def reload_page_view(page_view)
      G5PageView::PageView.first('_id'=>page_view[:_id])
    end
    before(:each) do
      @time_now = Time.now
      Time.stub!(:now).and_return(@time_now)
    end
    
    it "splits saved time into t as float and d as formatted date" do
      @pv.created_at=@time_now
      @pv.save!
      page_view= reload_page_view(@pv)
      page_view['created_at'].to_i.should eql(@time_now.to_i)
      page_view['sequence'].should eql(@time_now.to_f)
    end
  end

  context "validations" do
    it "should require url to be present" do
      pv = G5PageView::PageView[:session_id=>'123']
      lambda{ pv.save! }.should raise_error(G5PageView::Exceptions::MissingFields)
    end

    it "should require session_id to be present" do
      pv = G5PageView::PageView[:url=>"foobar"]
      lambda{ pv.save! }.should raise_error(G5PageView::Exceptions::MissingFields)
    end
  end
end

