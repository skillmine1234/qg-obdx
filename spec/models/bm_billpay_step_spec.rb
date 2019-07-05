require 'spec_helper'

describe BmBillpayStep do
  context 'association' do
    it { should belong_to(:bm_bill_payment) }
  end

  context 'validation' do
    [:bm_bill_payment_id, :step_no, :attempt_no, :step_name, :status_code].each do |att|
      it { should validate_presence_of(att) }
    end
  end
  
end