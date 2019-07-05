require 'spec_helper'

describe BmBillPaymentHelper do

  context "find_logs" do
    it "should return the logs" do
      transaction = Factory(:bm_bill_payment)
      log = Factory(:bm_billpay_step, :bm_bill_payment_id => transaction.id, :step_name => 'DEBIT')
      find_logs({:step_name => 'DEBIT'},transaction).should == transaction.bm_billpay_steps
      find_logs({:step_name => 'RETURN'},transaction).should == []
    end
  end
  
  context "payment_summary_count" do
    it "should return correct count" do
      payment_summary_count({["NEW","N"] => 1, ["NEW","Y"] => 1, ["SUCCESS","N"] => 1},['NEW','Y']).should == 1
      payment_summary_count({["FAILED","N"] => 1, ["SUCCESS","Y"] => 1, ["SUCCESS","N"] => 1},['SUCCESS','Y']).should == 1
      payment_summary_count({["FAILED","N"] => 1, ["SUCCESS","Y"] => 1, ["SUCCESS","N"] => 1},['FAILED','Y']).should == 0
    end
  end
end