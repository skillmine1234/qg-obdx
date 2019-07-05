require 'spec_helper'

describe BmAppsHelper do
  
  context "find_bm_apps" do
    it "should return bm_apps" do
      bm_app = Factory(:bm_app, :app_id => "12345", :approval_status => 'A')
      find_bm_apps({:app_id => "12345"}).should == [bm_app]
      find_bm_apps({:app_id => "98761"}).should_not == [bm_app]
      
      bm_app = Factory(:bm_app, :app_id => "12346", :channel_id => "sadfqwe23", :approval_status => 'A')
      find_bm_apps({:channel_id => "sadfqwe23"}).should == [bm_app]
      find_bm_apps({:biller_name => "dfqwe233"}).should_not == [bm_app]
    end
  end
end
