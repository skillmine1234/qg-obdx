# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define(:bm_bill_payment) do |i|
  i.sequence(:app_id) { |n| "key_#{n}" }
  i.sequence(:req_no) { |n| "req_#{n}" }
  i.sequence(:attempt_no) { |n| "attempt_#{n}" }
  i.sequence(:billpay_rep_ref) { |n| "rep_#{n}" }
  i.req_version "MyString"
  i.req_timestamp "2015-04-20 15:12:44"
  i.customer_id "1234"
  i.debit_account_no "1234"
  i.txn_kind 'debit'
  i.txn_amount 1230.0
  i.biller_code "AB123"
  i.biller_acct_no "12345"
  i.bill_id "4321"
  i.status "NEW"
  i.fault_code nil
  i.fault_reason nil
  i.debit_req_ref "2324"
  i.debited_at "2015-04-20 15:12:44"
  i.billpay_req_ref "2324"
  i.billpay_attempt_no 0 
  i.billpay_attempt_at "2015-04-20 15:12:44"
  i.billpaid_at "2015-04-20 15:12:44"
  i.reversal_req_ref nil
  i.reversal_attempt_no nil
  i.reversal_attempt_at nil
  i.reversal_rep_ref nil
  i.reversal_at nil
  i.refund_ref nil
  i.refund_at nil
  i.is_reconciled 'Y'
  i.reconciled_at "2015-04-20 15:12:44"
  i.pending_approval 'Y'
end