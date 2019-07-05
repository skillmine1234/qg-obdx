require 'spec_helper'

describe BmBiller do
  context 'association' do
    it { should belong_to(:created_user) }
    it { should belong_to(:updated_user) }
    it { should have_one(:bm_unapproved_record) }
    it { should belong_to(:unapproved_record) }
    it { should belong_to(:approved_record) }
  end
  
  context 'validation' do
    [:biller_code, :biller_name, :biller_category, :biller_location, :processing_method, :is_enabled, :num_params].each do |att|
      it { should validate_presence_of(att) }
    end 
    
    it do 
      bm_biller = Factory(:bm_biller, :approval_status => 'A')
      should validate_uniqueness_of(:biller_code).scoped_to(:approval_status)   
    end
  end
  
  context "biller code format" do 
    it "should allow valid format" do
      should allow_value('9876').for(:biller_code)
      should allow_value('ABCD90').for(:biller_code)
    end 
    
    it "should not allow invalid format" do
      should_not allow_value('@CUST01').for(:biller_code)
      should_not allow_value('CUST01/').for(:biller_code)
      should_not allow_value('CUST-01').for(:biller_code)
    end     
  end
  
  context "biller_name biller_location format" do 
    [:biller_name, :biller_location].each do |att|
      it "should allow valid format" do
        should allow_value('BillerName').for(att)
        should allow_value('Biller Name').for(att)
      end 
    
      it "should not allow invalid format" do
        should_not allow_value('@Biller').for(att)
        should_not allow_value('Biller/').for(att)
        should_not allow_value('Biller-8c*').for(att)
      end 
    end    
  end
  
  context "parameter name format" do 
    [:param1_name, :param2_name, :param3_name, :param4_name, :param5_name].each do |att|
      it "should allow valid format" do
        should allow_value('Param').for(att)
        should allow_value('Param1').for(att)
        should allow_value('Param(1)').for(att)
      end 
    
      it "should not allow invalid format" do
        should_not allow_value('@Param').for(att)
        should_not allow_value('param!!').for(att)
        should_not allow_value('Param-8c*').for(att)
      end
    end   
  end
  
  context "default_scope" do 
    it "should only return 'A' records by default" do 
      bm_biller1 = Factory(:bm_biller, :approval_status => 'A') 
      bm_biller2 = Factory(:bm_biller, :biller_code => '12we')
      BmBiller.all.should == [bm_biller1]
      bm_biller2.approval_status = 'A'
      bm_biller2.save
      BmBiller.all.should == [bm_biller1,bm_biller2]
    end
  end    

  context "bm_unapproved_records" do 
    it "oncreate: should create bm_unapproved_record if the approval_status is 'U'" do
      bm_biller = Factory(:bm_biller)
      bm_biller.reload
      bm_biller.bm_unapproved_record.should_not be_nil
    end

    it "oncreate: should not create bm_unapproved_record if the approval_status is 'A'" do
      bm_biller = Factory(:bm_biller, :approval_status => 'A')
      bm_biller.bm_unapproved_record.should be_nil
    end

    it "onupdate: should not remove bm_unapproved_record if approval_status did not change from U to A" do
      bm_biller = Factory(:bm_biller)
      bm_biller.reload
      bm_biller.bm_unapproved_record.should_not be_nil
      record = bm_biller.bm_unapproved_record
      # we are editing the U record, before it is approved
      bm_biller.biller_location = 'Fooo'
      bm_biller.save
      bm_biller.reload
      bm_biller.bm_unapproved_record.should == record
    end
    
    it "onupdate: should remove bm_unapproved_record if the approval_status changed from 'U' to 'A' (approval)" do
      bm_biller = Factory(:bm_biller)
      bm_biller.reload
      bm_biller.bm_unapproved_record.should_not be_nil
      # the approval process changes the approval_status from U to A for a newly edited record
      bm_biller.approval_status = 'A'
      bm_biller.save
      bm_biller.reload
      bm_biller.bm_unapproved_record.should be_nil
    end
    
    it "ondestroy: should remove bm_unapproved_record if the record with approval_status 'U' was destroyed (approval) " do
      bm_biller = Factory(:bm_biller)
      bm_biller.reload
      bm_biller.bm_unapproved_record.should_not be_nil
      record = bm_biller.bm_unapproved_record
      # the approval process destroys the U record, for an edited record 
      bm_biller.destroy
      BmUnapprovedRecord.find_by_id(record.id).should be_nil
    end
  end

  context "approve" do 
    it "should approve unapproved_record" do 
      bm_biller = Factory(:bm_biller, :approval_status => 'U')
      bm_biller.approve.should == ""
      bm_biller.approval_status.should == 'A'
    end

    it "should return error when trying to approve unmatched version" do 
      bm_biller = Factory(:bm_biller, :approval_status => 'A')
      bm_biller1 = Factory(:bm_biller, :approval_status => 'U', :approved_id => bm_biller.id, :approved_version => 6)
      bm_biller1.approve.should == "The record version is different from that of the approved version" 
    end
  end

  context "enable_approve_button?" do 
    it "should return true if approval_status is 'U' else false" do 
      bm_biller1 = Factory(:bm_biller, :approval_status => 'A')
      bm_biller2 = Factory(:bm_biller, :approval_status => 'U')
      bm_biller1.enable_approve_button?.should == false
      bm_biller2.enable_approve_button?.should == true
    end
  end
  
  context "options_for_processing_method" do
    it "should return options for processing method" do
      BmBiller.options_for_processing_method.should == [['Presentment','T'],['Payee','P'],['Both','A'],['Recharge','R']]
    end
  end
end