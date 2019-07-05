# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :bm_rule do
    sequence(:app_id) {|n| "%03i" % "#{n}"}
    cod_acct_no "1234567890"
    customer_id "KFCJSDH"
    bene_acct_no "ACC122ABC"
    bene_account_ifsc "ASDF0123456"
    neft_sender_ifsc "ASDF0543210"
    approval_status 'U'
    last_action 'C'
  end
end
