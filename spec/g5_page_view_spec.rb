require 'spec_helper'

describe G5PageView do
  before(:each) do
    @real_connection= G5PageView::connection
  end
  
  describe "Connection" do
    it "raise an error if no nodes are specified" do
      lambda{ G5PageView::connect!({:nodes=>nil}) }.should raise_error('Invalid nodes specified')
    end
    
    it "raise an error if the nodes specified are not an array" do
      lambda{ G5PageView::connect!({:nodes=>{}}) }.should raise_error('Invalid nodes specified')      
    end
    
    it "should be connected to the replica set" do
      G5PageView::connection.should be_connected
    end
    
    it "symbolize the configs" do
      config= {"test"=>{"nodes"=>["localhost:27017"], "name"=>'gts_replica_test', 'database'=>'gts_test'}}
      G5PageView::symbolize(config['test']).should eql({:nodes=>["localhost:27017"], :name=>'gts_replica_test', :database=>'gts_test'})
    end
    
    it "should connect with the symbolized configs" do
      config= {"test"=>{"nodes"=>["localhost:27017"], "name"=>'gts_replica_test', 'database'=>'gts_test'}}
      Mongo::ReplSetConnection.should_receive(:new).with(["localhost:27017"], {:name=>'gts_replica_test'}).and_return(@real_connection)
      G5PageView::connect!(config['test'])
    end
  end
end
