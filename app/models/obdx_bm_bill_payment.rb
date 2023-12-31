class ObdxBmBillPayment < ActiveRecord::Base  
  #establish_connection "obdx_#{Rails.env}"
  self.table_name = "bm_bill_payments"

  has_many :obdx_bm_billpay_steps

  
  #validates_presence_of :app_id, :req_no, :attempt_no, :customer_id, :debit_account_no, :txn_kind,
                        #:txn_amount, :status
                        
  def self.find_bm_bill_payments(bm_bill_payment,params)
    bill_payments = bm_bill_payment
    bill_payments = bill_payments.where("bm_bill_payments.req_no LIKE ?","#{params[:req_no]}%") if params[:req_no].present?
    bill_payments = bill_payments.where("bm_bill_payments.customer_id=?",params[:customer_id]) if params[:customer_id].present?
    bill_payments = bill_payments.where("bm_bill_payments.debit_account_no=?",params[:debit_account_no]) if params[:debit_account_no].present?
    bill_payments = bill_payments.where("bm_billf_payments.biller_id=?",params[:biller_id]) if params[:biller_id].present?
    bill_payments = bill_payments.where("bm_bill_payments.biller_acct_id=?",params[:biller_acct_id]) if params[:biller_acct_id].present?
    bill_payments = bill_payments.where("bm_bill_payments.status=?",params[:status]) if params[:status].present?
    bill_payments = bill_payments.where("bm_bill_payments.billpay_req_ref=?",params[:billpay_req_ref]) if params[:billpay_req_ref].present?
    bill_payments = bill_payments.where("bm_bill_payments.billpay_rep_ref=?",params[:billpay_rep_ref]) if params[:billpay_rep_ref].present?
    bill_payments = bill_payments.where("bm_bill_payments.biller_status=?",params[:biller_status]) if params[:biller_status].present?
    bill_payments = bill_payments.where("bm_bill_payments.payment_status=?",params[:payment_status]) if params[:payment_status].present?
    bill_payments = bill_payments.where("bm_bill_payments.payment_method=?",params[:payment_method]) if params[:payment_method].present?
    bill_payments = bill_payments.where("bm_bill_payments.isbbps=?",params[:isbbps]) if params[:isbbps].present?
    bill_payments
  end
                        
  def self.to_csv(csv_path, params)
    Delayed::Worker.logger.debug("called ")
    if params[:advanced_search].present? || params[:summary].present?
      requests = find_bm_bill_payments(self,params).order("id desc")
    else
      requests = all.order("id desc")
    end
    CSV.open(csv_path,'w') do |csv|
      csv << get_header
      requests.find_each(batch_size: 100) do |t|
        csv << [t.app_id, t.req_no, t.attempt_no, t.req_version, t.req_timestamp, t.customer_id, t.debit_account_no, t.txn_kind, 
                t.txn_amount, t.biller_code, t.biller_acct_no, t.bill_id, t.status, t.fault_code, t.fault_reason, t.debit_req_ref, 
                t.debit_attempt_no, t.debit_attempt_at, t.debit_rep_ref, t.debited_at, t.billpay_req_ref, t.billpay_attempt_no, 
                t.billpay_attempt_at, t.billpay_rep_ref, t.billpaid_at, t.reversal_req_ref, t.reversal_attempt_no, t.reversal_attempt_at, 
                t.reversal_rep_ref, t.reversal_at, t.refund_ref, t.refund_at, t.is_reconciled, t.reconciled_at, t.pending_approval, 
                t.service_id, t.rep_no, t.rep_version, t.rep_timestamp, t.param1, t.param2, t.param3, t.param4, t.param5, 
                t.cod_pool_acct_no, t.bill_date, t.due_date, t.bill_number, t.billpay_bank_ref]
      end
    end
  end

  def self.get_header
    ['App ID', 'Request No', 'Attempt No', 'Request Version', 'Request Timestamp', 'Customer ID', 'Debit Account No', 'Txn Kind', 
     'Txn Amount', 'Biller Code', 'Biller Account No', 'Bill ID', 'Status', 'Fault Code', 'Fault Reason', 'Debit Req Ref', 
     'Debit Attempt No', 'Debit Attempt At', 'Debit Rep Ref', 'Debited At', 'Billpay Req Ref', 'Billpay Attempt No', 
     'Billpay Attempt At', 'Billpay Rep Ref', 'Billpaid At', 'Reversal Req Ref', 'Reversal Attempt No', 'Reversal Attempt At',
     'Reversal Rep Ref', 'Reversal At', 'Refund Ref', 'Refund At', 'Is Reconciled', 'Reconciled At', 'Pending Approval', 
     'Service ID', 'Reply No', 'Reply Version', 'Reply Timestamp', 'Param1', 'Param2', 'Param3', 'Param4', 'Param5', 
     ' Cod Pool Account No', 'Bill Date', 'Due Date', 'Bill Number', 'Billpay Bank Ref']
  end
  
  def self.payment_mode_records(payment_mode,start_date=nil,end_date=nil)
    if start_date.present? && end_date.present?
      start_date = Date.parse(start_date).strftime("%d-%m-%y")
      end_date = Date.parse(end_date).strftime("%d-%m-%y")
      where("payment_method = ? and payment_status = 'SUCCESS' and req_timestamp BETWEEN '#{start_date}' and '#{end_date}'", payment_mode)
    else
      all
    end
  end

  def self.fetch_for_wallet_format(start_date, end_date)
    start_date = Date.parse(start_date).strftime("%d-%m-%y")
    end_date = Date.parse(end_date).strftime("%d-%m-%y")
    if start_date.present? && end_date.present?
      where("payment_method = ? and req_timestamp BETWEEN '#{start_date}' and '#{end_date}'", 'Wallet')
    else
      where("payment_method = ?", 'Wallet')
    end
  end

  def self.fetch_for_cc_format(start_date, end_date)
    start_date = Date.parse(start_date).strftime("%d-%m-%y")
      end_date = Date.parse(end_date).strftime("%d-%m-%y")
    if start_date.present? && end_date.present?
      where("payment_method = ? and req_timestamp BETWEEN '#{start_date}' and '#{end_date}'", 'CreditCard')
    else
      where("payment_method = ?", 'CreditCard')
    end
  end

  def success_bm_billpay_steps
    where(step_name: 'WALLET_DEBITED', status_code: 'COMPLETED').last
  end
 
 def records_bill_pay_status
    success_records = self.obdx_bm_billpay_steps.where(step_name: 'WALLET_DEBITED', status_code: 'COMPLETED').last
    failure_records = self.obdx_bm_billpay_steps.where(step_name: 'WALLET_DEBIT', status_code: 'FAILED').last
    return records_bill_pay_status = success_records.any? ? "SUCCESS" : failure_records.any? ? "FAILED" : ''
 end

def records_cc_status
  approved_records = self.obdx_bm_billpay_steps.where(step_name: 'CREDIT_CARD_DEBITED', status_code: 'COMPLETED').last
  declined_records = self.obdx_bm_billpay_steps.where(step_name: 'CREDITCARD_DEBIT', status_code: 'FAILED').last
  records_cc_status = approved_records.any? ? "APPROVE" : declined_records.any? ? "DECLINE" : ''
end

def records_bill_pay_status
  success_records = self.obdx_bm_billpay_steps.where(step_name: 'BILLPAY', status_code: 'COMPLETED').last
  failure_records = self.obdx_bm_billpay_steps.where(step_name: 'BILLPAY', status_code: 'FAILED').last
  return records_bill_pay_status = success_records.any? ? "SUCCESS" : failure_records.any? ? "FAILED" : ''
end

def card_start_end_no
  return card_start_end_no = self.card_start + 'XXXXXX' + self.card_end
end

end