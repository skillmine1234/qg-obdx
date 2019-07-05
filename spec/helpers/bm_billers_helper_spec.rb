require 'spec_helper'

describe BmBillersHelper do
  context "find_bm_billers" do
    it "should return bm_billers" do
      bm_biller = Factory(:bm_biller, :biller_code => "12345", :approval_status => 'A')
      find_bm_billers({:biller_code => "12345"}).should == [bm_biller]
      find_bm_billers({:biller_code => "98761"}).should_not == [bm_biller]
      
      bm_biller = Factory(:bm_biller, :biller_code => "12346", :biller_name => "Airtel", :approval_status => 'A')
      find_bm_billers({:biller_name => "Airtel"}).should == [bm_biller]
      find_bm_billers({:biller_name => "BSNL"}).should_not == [bm_biller]
      
      bm_biller = Factory(:bm_biller, :biller_code => "12347", :biller_category => "Telecom", :approval_status => 'A')
      find_bm_billers({:biller_category => "Telecom"}).should == [bm_biller]
      find_bm_billers({:biller_category => "Electricity"}).should_not == [bm_biller]
      
      bm_biller = Factory(:bm_biller, :biller_code => "12348", :processing_method => "P", :approval_status => 'A')
      find_bm_billers({:processing_method => "P"}).should == [bm_biller]
      find_bm_billers({:processing_method => "A"}).should_not == [bm_biller]
      
      bm_biller = Factory(:bm_biller, :biller_code => "12349", :is_enabled => "Y", :approval_status => 'A')
      find_bm_billers({:is_enabled => "Y"}).should == [bm_biller]
      find_bm_billers({:is_enabled => "N"}).should_not == [bm_biller]
    end
  end
end
