require 'spec_helper'

describe BmAggregatorPaymentsHelper do
  context 'find_bm_aggregator_payment' do
    it 'should return bm_aggregator_payments' do
      bm_aggregator_payments = Factory(:bm_aggregator_payment, :cod_acct_no => '1234567890', :approval_status => 'A')
      find_bm_aggregator_payments({:cod_acct_no => '1234567890'}).should == [bm_aggregator_payments]
      find_bm_aggregator_payments({:cod_acct_no => '76123tgy1'}).should == []
      
      bm_aggregator_payment = Factory(:bm_aggregator_payment,:status => 'IN_PROCESS', :approval_status => 'A')
      find_bm_aggregator_payments({:status => 'IN_PROCESS'}).should == [bm_aggregator_payment]
      find_bm_aggregator_payments({:status => 'COMPLETED'}).should == []
  
      bm_aggregator_payment = Factory(:bm_aggregator_payment,:neft_sender_ifsc => '12345', :approval_status => 'A')
      find_bm_aggregator_payments({:neft_sender_ifsc => '12345'}).should == [bm_aggregator_payment]
      find_bm_aggregator_payments({:neft_sender_ifsc => 'asdas'}).should == []

      bm_aggregator_payment = Factory(:bm_aggregator_payment,:bene_acct_no => '98762', :approval_status => 'A')
      find_bm_aggregator_payments({:bene_acct_no => '98762'}).should == [bm_aggregator_payment]
      find_bm_aggregator_payments({:bene_acct_no => '98u9u'}).should == []

      bm_aggregator_payment1 = Factory(:bm_aggregator_payment, :payment_amount => '10000', :approval_status => 'A')
      bm_aggregator_payment2 = Factory(:bm_aggregator_payment, :payment_amount => '9000', :approval_status => 'A')
      bm_aggregator_payment3 = Factory(:bm_aggregator_payment, :payment_amount => '8000', :approval_status => 'A')
      find_bm_aggregator_payments({:from_amount => '8000', :to_amount => '10000'}).should == [bm_aggregator_payment1,bm_aggregator_payment2,bm_aggregator_payment3]
      find_bm_aggregator_payments({:from_amount => '10000', :to_amount => '12000'}).should == [bm_aggregator_payment1]
      
      bm_aggregator_payment = [Factory(:bm_aggregator_payment, :created_at => '2015-04-25', :approval_status => 'A')]
      bm_aggregator_payment << Factory(:bm_aggregator_payment, :created_at => '2015-04-26', :approval_status => 'A')
      bm_aggregator_payment << Factory(:bm_aggregator_payment, :created_at => '2015-04-27', :approval_status => 'A')
      find_bm_aggregator_payments({:from_date => '2015-04-25', :to_date => '2015-04-27'}).should == bm_aggregator_payment
      find_bm_aggregator_payments({:from_date => '2015-04-28', :to_date => '2015-04-30'}).should == []
    end
  end
end
