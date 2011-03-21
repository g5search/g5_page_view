require 'spec_helper'

describe G5PageView do
  before(:each) do
    @real_connection= G5PageView::connection
  end
  
  describe "Connection" do
    describe "Reconnect" do
      before(:each) do
        @config = {"test"=>{"nodes"=>[["localhost", "27017"]], "rs_name"=>'gts_replica_test', 'database'=>'gts_test'}}
        @new_connection = mock(Mongo::ReplSetConnection).as_null_object
        Mongo::ReplSetConnection.should_receive(:new).and_return(@new_connection)
      end
      it "should reassign the connection instance variable" do
        old_connection = G5PageView::connection
        G5PageView::reconnect!
        G5PageView.connection.should_not eql(old_connection)
      end
      it "should reassign the config instance variable" do
        old_db= G5PageView::db
        G5PageView::reconnect!
        G5PageView::db.should_not eql(old_db)        
      end
      it "should reassign the database instance variable" do
        old_config= G5PageView::config
        G5PageView::reconnect!
        G5PageView::config.should_not equal(old_config)
      end
    end
    
    describe "Database" do
      before(:each) do
        @config= {"nodes"=>[["localhost", "27017"]], 'database'=>'gts_test'}
      end
      it "raise an error if no database is specified" do
        @config.delete('database')
        lambda{ G5PageView::connect!(@config) }.should raise_error('No database specified')        
      end
      
      it "gets the database when connected" do
        G5PageView::connect!(@config)
        db= G5PageView::db
        db.name.should eql(G5PageView::config[:database])
      end
    end
    
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
      config= {"test"=>{"nodes"=>[["localhost", "27017"]], "rs_name"=>'gts_replica_test', 'database'=>'gts_test'}}
      G5PageView::symbolize(config['test']).should eql({:nodes=>[["localhost", "27017"]], :rs_name=>'gts_replica_test', :database=>'gts_test'})      
    end
    
    it "should connect with the symbolized configs" do
      config= {"test"=>{"nodes"=>[["localhost", "27017"]], "rs_name"=>'gts_replica_test', 'database'=>'gts_test'}}
      Mongo::ReplSetConnection.should_receive(:new).with(["localhost", "27017"], {:rs_name=>'gts_replica_test', :database=>'gts_test'}).and_return(@real_connection)
      G5PageView::connect!(config['test'])
    end
  end
end
