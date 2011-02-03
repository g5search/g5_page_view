require "spec_helper"

describe G5PageView::SearchEngine do
  before(:each) do
    @search_engine= G5PageView::SearchEngine[:source_host, 'www.google.com']
    @valid= G5PageView::SearchEngine[:search_engine, 'google', :source_host, 'www.google.com', :keyword_param, 'q', :campaign_rule, 'q']
  end
  
  describe "Access" do
    it "get the source_host if it exists" do
      @search_engine[:source_host].should eql('www.google.com')
    end
  end
  
  describe "Saving" do
    def reset!(hash)
      new_hash= G5PageView::SearchEngine.new
      hash.each{|k,v| new_hash[k]=v}
      new_hash
    end
    
    before(:each) do
      @required_fields_assertion= Proc.new do |search_engine|  
        search_engine.required_fields.each do |f|
          constant= reset!(@valid)
          @valid[f] = nil
          lambda{ @valid.save! }.should raise_error(G5PageView::Exceptions::MissingFields)
          @valid= constant
        end        
      end
    end

    it "should raise a MissingField exception if any of the required fields aren't set" do
      @required_fields_assertion.call(@search_engine)
    end

    it "should insert the search engine with the specified fields" do
      expect { @valid.save! }.to change(G5PageView::SearchEngine.collection, :count).by(1)
    end
  end
end