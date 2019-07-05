FactoryGirl.define do
  factory :bm_aggregator_payment do
    cod_acct_no "0987654321"
    approval_status "U"
    neft_sender_ifsc "ASDF0123456"
    bene_name "Bene"
    bene_acct_no "09876546789"
    bene_acct_ifsc "EQWE0123456"
    customer_id "43123"
    service_id "1238912"
    payment_amount "1000"
    rmtr_name "RMTR"
    rmtr_to_bene_note "notes"
  end
end