require 'spec_helper'

describe Campaign do
  describe "Parsing" do
    before(:all) do
      Seeds::SearchEngineSeed.execute
    end
    after(:all) do
      Seeds::SearchEngineSeed.undo
    end
    
    it "should not have an engine if there is no matching campaign" do
      Campaign.parse('foobarsda1').should be_nil      
    end
    
    it "should be google" do
      Campaign.parse('glsda1').should eql('www.google.com')
    end

    it "should be bing" do
      Campaign.parse('blsda1').should eql('www.bing.com')
    end
    
    it "should be yahoo" do
      Campaign.parse('ylsda1').should eql('search.yahoo.com')      
    end

    it "should be facebook" do
      Campaign.parse('fblsda1').should eql('www.facebook.com')            
    end
    
    it "should be ineedstorage" do
      Campaign.parse('inssda1').should eql('www.ineedstorage.com')      
    end
    
    it "should be selfstorage" do
      Campaign.parse('sssda1').should eql('www.selfstorage.com')            
    end
    
    it "should be usstorage" do
      Campaign.parse('usssda1').should eql('www.usstorage.com')                  
    end
  end
end
