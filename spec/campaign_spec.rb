require 'spec_helper'

describe G5PageView::Campaign do
  describe "Parsing" do
    
    it "should not have an engine if there is no matching campaign" do
      G5PageView::Campaign.parse('foobarsda1').should be_nil      
    end
    
    it "should be google" do
      G5PageView::Campaign.parse('glsda1').should eql('www.google.com')
    end

    it "should be bing" do
      G5PageView::Campaign.parse('blsda1').should eql('www.bing.com')
    end
    
    it "should be yahoo" do
      G5PageView::Campaign.parse('ylsda1').should eql('search.yahoo.com')      
    end

    it "should be facebook" do
      G5PageView::Campaign.parse('fblsda1').should eql('www.facebook.com')            
    end
    
    it "should be ineedstorage" do
      G5PageView::Campaign.parse('inssda1').should eql('www.ineedstorage.com')      
    end
    
    it "should be selfstorage" do
      G5PageView::Campaign.parse('sssda1').should eql('www.selfstorage.com')            
    end
    
    it "should be usstorage" do
      G5PageView::Campaign.parse('usssda1').should eql('www.usstorage.com')                  
    end
  end
end
