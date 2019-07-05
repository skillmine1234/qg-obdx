# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bm_billpay_step do
    bm_bill_payment_id 1
    step_name "MyString"
    attempt_no 1
    fault_code "MyString"
    fault_reason "MyString"
    req_bitstream "MyText"
    rep_bitstream "MyText"
    fault_bitstream "MyText"
    step_no 1
    status_code 'PASSED'
  end
end
