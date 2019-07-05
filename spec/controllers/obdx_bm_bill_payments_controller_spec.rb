require 'spec_helper'
require "cancan_matcher"

describe ObdxBmBillPaymentsController do
  include HelperMethods

  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
  end

  describe "GET index" do
    it "assigns all bm_bill_payments as @bm_bill_payments" do
      bm_bill_payment = Factory(:bm_bill_payment)
      get :index
      assigns(:bm_bill_payments).should eq([bm_bill_payment])
    end
  end

  describe "GET show" do
    it "assigns the requested bm_bill_payment as @bm_bill_payment" do
      bm_bill_payment = Factory(:bm_bill_payment)
      get :show, {:id => bm_bill_payment.id}
      assigns(:bill_payment).should eq(bm_bill_payment)
    end
  end

  describe "GET audit_logs" do
    it "returns the debit log" do
      bill_payment = Factory(:bm_bill_payment)
      log = Factory(:bm_billpay_step, :bm_bill_payment_id => bill_payment.id, :step_name => 'DEBIT')
      get :audit_logs, :id => bill_payment.id, :step_name => 'DEBIT'
      assigns[:bill_values].should == [log]
    end

    it "returns the billpay log" do
      bill_payment = Factory(:bm_bill_payment)
      log = Factory(:bm_billpay_step, :bm_bill_payment_id => bill_payment.id, :step_name => 'BILLPAY')
      get :audit_logs, :id => bill_payment.id, :step_name => 'BILLPAY'
      assigns[:bill_values].should == [log]
    end

    it "returns the reversal log" do
      bill_payment = Factory(:bm_bill_payment)
      log = Factory(:bm_billpay_step, :bm_bill_payment_id => bill_payment.id, :step_name => 'REVERSAL')
      get :audit_logs, :id => bill_payment.id, :step_name => 'REVERSAL'
      assigns[:bill_values].should == [log]
    end
  end
end