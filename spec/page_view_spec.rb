require "spec_helper"

describe PageView do
  before do
    @pv = PageView.new(:visitor_cookie =>"acookie", :url=>"http://someurl.com", :session_id=>"123")
  end

  it "should parse the domain for the request" do
    @pv.domain.should eql('someurl.com')
  end
  
  it "should parse the domain for the previous request" do
    @pv.referring_url='http://www.google.com'
    @pv.referring_domain.should eql('www.google.com')
  end
  
  it "should be nil if the domain is unparsable" do
    @pv.parse_domain('a bad uri').should be_nil
  end

  context 'Attributing traffic to source,channel,campaign' do
    it "should attribute the traffic before saving" do
      traffic = TrafficAttributionFactory.new
      TrafficAttributionFactory.stub!(:new).and_return(traffic)
      traffic.should_receive(:update!).with(@pv)
      @pv.save
    end
  end

  context "date & time split" do
    before(:each) do
      @time_now = Time.now
      Time.stub!(:now).and_return(@time_now)
    end

    it "splits saved time into t as float and d as formatted date" do
      @pv.save!
      @pv.reload
      @pv.created_at.to_i.should eql(@time_now.to_i)
      @pv.sequence.should eql(@time_now.to_f)
    end

    it "should use the created_at if set (and set the sequence)" do
      created_at= Time.now
      @pv.created_at= created_at
      @pv.save
      @pv.created_at.to_i.should eql(created_at.to_i)
      @pv.sequence.should eql(created_at.to_f)
    end
  end

  context "validations" do
    it "should require url to be present" do
      pv = PageView.new(:session_id=>'123')
      pv.save
      pv.should_not be_valid
      pv.errors.on(:url).should == "can't be blank"
    end

    it "should require session_id to be present" do
      pv = PageView.new(:url=>"foobar")
      pv.save
      pv.should_not be_valid
      pv.errors.on(:session_id).should == "can't be blank"
    end
  end
end

