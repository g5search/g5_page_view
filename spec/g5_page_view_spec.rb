require 'spec_helper'

describe G5PageView do
  let(:config) { {"nodes"=>["localhost:27017"], "name"=>'gts_replica_test', 'database'=>'gts_test'} }
  
  describe "Connection" do
    describe "Set class variables in connection" do
      before do
        @db = stub
        @conn = stub(:db => @db)
        G5PageView.stub(:mongo_connect => @conn)
      end

      it "should set class variables correctly" do
        G5PageView::connect!(config)
        G5PageView.connection.should == @conn
        G5PageView.db.should == @db
        G5PageView.config.should == G5PageView::symbolize(config)
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
      G5PageView::symbolize(config).should eql({:nodes=>["localhost:27017"], :name=>'gts_replica_test', :database=>'gts_test'})
    end

    describe "#connect!" do
      it "should call mongo connect" do
        G5PageView.should_receive(:mongo_connect).and_return(stub(:db => stub))
        G5PageView::connect!(config)
      end
    end

    describe "#mongo_connect" do
      let (:options) { {:name => 'gts_replica_test'} }

      it "should use the repl set connection" do
        Mongo::ReplSetConnection.should_receive(:new).with(["localhost:27017"], options)
        G5PageView::mongo_connect( config['nodes'], options )
      end
      it "should degrade to the Mongo connection" do
        Mongo::ReplSetConnection.should_receive(:new).and_raise(Mongo::ConnectionFailure)
        Mongo::Connection.should_receive(:new).with("localhost", "27017")
        G5PageView::mongo_connect( config['nodes'], options )
      end
    end

    describe "#reconnect!" do
      it "should reconnect" do
        G5PageView::connect! config
        symbolized_config = G5PageView::symbolize config
        G5PageView.config.should == symbolized_config
        subject.should_receive(:connect!).with(symbolized_config)
        G5PageView::reconnect!
      end
    end
  end
end
