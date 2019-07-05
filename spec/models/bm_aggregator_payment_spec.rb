require 'spec_helper'

describe BmAggregatorPayment do
  context 'association' do
    it { should have_one(:bm_unapproved_record) }
    it { should belong_to(:unapproved_record) }
    it { should belong_to(:approved_record) }
    it { should have_one(:bm_audit_log) }
  end
  
  context 'validation' do
    [:cod_acct_no, :neft_sender_ifsc, :bene_acct_no, :bene_acct_ifsc, :status, :bene_name, :customer_id, :payment_amount, :rmtr_name, :rmtr_to_bene_note].each do |att|
      it { should validate_presence_of(att) }
    end 
  end
  
  context "default_scope" do 
    it "should only return 'A' records by default" do 
      bm_aggregator_payment1 = Factory(:bm_aggregator_payment, :approval_status => 'A') 
      bm_aggregator_payment2 = Factory(:bm_aggregator_payment, :cod_acct_no => '1234567890')
      BmAggregatorPayment.all.should == [bm_aggregator_payment1]
      bm_aggregator_payment2.approval_status = 'A'
      bm_aggregator_payment2.save
      BmAggregatorPayment.all.should == [bm_aggregator_payment1,bm_aggregator_payment2]
    end
  end    

  context "bm_unapproved_records" do 
    it "oncreate: should create bm_unapproved_record if the approval_status is 'U'" do
      bm_aggregator_payment = Factory(:bm_aggregator_payment)
      bm_aggregator_payment.reload
      bm_aggregator_payment.bm_unapproved_record.should_not be_nil
    end

    it "oncreate: should not create bm_unapproved_record if the approval_status is 'A'" do
      bm_aggregator_payment = Factory(:bm_aggregator_payment, :approval_status => 'A')
      bm_aggregator_payment.bm_unapproved_record.should be_nil
    end

    it "onupdate: should not remove bm_unapproved_record if approval_status did not change from U to A" do
      bm_aggregator_payment = Factory(:bm_aggregator_payment)
      bm_aggregator_payment.reload
      bm_aggregator_payment.bm_unapproved_record.should_not be_nil
      record = bm_aggregator_payment.bm_unapproved_record
      # we are editing the U record, before it is approved
      bm_aggregator_payment.cod_acct_no = '1234567890'
      bm_aggregator_payment.save
      bm_aggregator_payment.reload
      bm_aggregator_payment.bm_unapproved_record.should == record
    end
    
    it "onupdate: should remove bm_unapproved_record if the approval_status changed from 'U' to 'A' (approval)" do
      bm_aggregator_payment = Factory(:bm_aggregator_payment)
      bm_aggregator_payment.reload
      bm_aggregator_payment.bm_unapproved_record.should_not be_nil
      # the approval process changes the approval_status from U to A for a newly edited record
      bm_aggregator_payment.approval_status = 'A'
      bm_aggregator_payment.save
      bm_aggregator_payment.reload
      bm_aggregator_payment.bm_unapproved_record.should be_nil
    end
    
    it "ondestroy: should remove bm_unapproved_record if the record with approval_status 'U' was destroyed (approval) " do
      bm_aggregator_payment = Factory(:bm_aggregator_payment)
      bm_aggregator_payment.reload
      bm_aggregator_payment.bm_unapproved_record.should_not be_nil
      record = bm_aggregator_payment.bm_unapproved_record
      # the approval process destroys the U record, for an edited record 
      bm_aggregator_payment.destroy
      BmUnapprovedRecord.find_by_id(record.id).should be_nil
    end
  end

  context "approve" do 
    it "should approve unapproved_record" do 
      bm_aggregator_payment = Factory(:bm_aggregator_payment, :approval_status => 'U')
      bm_aggregator_payment.approve.should == ""
      bm_aggregator_payment.approval_status.should == 'A'
    end

    it "should return error when trying to edit approved_record" do 
      bm_aggregator_payment = Factory(:bm_aggregator_payment, :approval_status => 'A')
      bm_aggregator_payment1 = Factory.build(:bm_aggregator_payment, :approval_status => 'U', :approved_id => bm_aggregator_payment.id, :approved_version => 1)
      bm_aggregator_payment1.save.should == false
      bm_aggregator_payment1.errors[:base].should == ["You cannot edit this record as it is already approved!"]
    end
  end

  context "enable_approve_button?" do 
    it "should return true if approval_status is 'U' else false" do 
      bm_aggregator_payment1 = Factory(:bm_aggregator_payment, :approval_status => 'A')
      bm_aggregator_payment2 = Factory(:bm_aggregator_payment, :approval_status => 'U')
      bm_aggregator_payment1.enable_approve_button?.should == false
      bm_aggregator_payment2.enable_approve_button?.should == true
    end
  end

end