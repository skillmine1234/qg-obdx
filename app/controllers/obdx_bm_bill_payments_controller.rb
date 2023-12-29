require 'will_paginate/array'

class ObdxBmBillPaymentsController < ApplicationController
  #authorize_resource
  before_action :authenticate_user!
  before_action :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  include ObdxBmBillPaymentHelper

  def show
    @bill_payment = ObdxBmBillPayment.find_by_id(params[:id])
  end

  def index
    bm_bill_payments = ObdxBmBillPayment.order("id desc")
    bm_bill_payments = ObdxBmBillPayment.find_bm_bill_payments(bm_bill_payments,params) if params[:advanced_search].present? || params[:summary].present?
    @bm_bill_payments_count = bm_bill_payments.count
    @bm_bill_payments = bm_bill_payments.paginate(:per_page => 10, :page => params[:page]) rescue []
    
    if params[:ExportToCSV]
      className = 'ObdxBmBillPayment'
      groupName = 'Bill Management2.0'
      csv_export = CsvExport.create(state: 'in_progress', user_id: current_user.id, request_type: className, group: groupName)
      csv_path = csv_export.csv_path
      ExportCsvJob.perform_later(className, csv_path, params, csv_export)
    end
  end

  def audit_logs
    @bill_payment = ObdxBmBillPayment.find(params[:id])
    bill_values = find_logs(params, @bill_payment)
    @bill_values_count = bill_values.count(:id)
    @bill_values = bill_values.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  private

  def bm_bill_payment_params
    params.require(:bm_bill_payment).permit(:app_id, :req_no, :attempt_no, :req_version, :req_timestamp,
          :customer_id, :debit_account_no, :txn_kind, :txn_amount, :biller_code, :biller_acct_no, 
          :bill_id, :status, :fault_code, :fault_reason, :debit_req_ref, :debit_attempt_no, 
          :debit_attempt_at, :debit_rep_ref, :debited_at, :billpay_req_ref, :billpay_attempt_no, 
          :billpay_attempt_at, :billpay_rep_ref, :billpaid_at, :reversal_req_ref, :reversal_attempt_no, 
          :reversal_attempt_at, :reversal_rep_ref, :reversal_at, :refund_ref, :refund_at, 
          :is_reconciled, :reconciled_at, :pending_approval)
  end
end