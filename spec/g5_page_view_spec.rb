require 'spec_helper'

describe G5PageView do
  before(:each) do
    @real_connection= G5PageView::connection
  end
  
  describe "Connection" do
    describe "Database" do
      it "gets the database when connected" do
        db= G5PageView::db
        db.name.should eql(G5PageView::config['database'])
      end
    end
    
    it "raise an error if no nodes are specified" do
      lambda{ G5PageView::connect!({:nodes=>nil}) }.should raise_error('Invalid nodes specified')
    end
    
    it "raise an error if the nodes specified are not an array" do
      lambda{ G5PageView::connect!({:nodes=>{}}) }.should raise_error('Invalid nodes specified')      
    end
    
    it "should connect to the replica set" do
      config= {"test"=>{"nodes"=>[["localhost", "27017"]]}}
      G5PageView::connect!(config['test'])
      G5PageView::connection.should be_connected
    end
    
    it "should connect with the symbolized configs" do
      config= {"test"=>{"nodes"=>[["localhost", "27017"]], "rs_name"=>'gts_replica_test'}}
      Mongo::ReplSetConnection.should_receive(:new).with(["localhost", "27017"], {:rs_name=>'gts_replica_test'}).and_return(@real_connection)
      G5PageView::connect!(config['test'])
    end
  end
end
