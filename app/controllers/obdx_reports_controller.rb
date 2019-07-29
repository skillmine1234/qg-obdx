class ObdxReportsController < ApplicationController
  # authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  require 'fileutils'

  require 'csv'
  require 'zip'
  include ApplicationHelper

  def index
  end

  def new
    generate_report(params[:report_type],params[:from_date],params[:to_date])
  end

  def generate_report(report_type,start_date=nil,end_date=nil)
    if report_type == 'bill_desk'
      csvs = []
      ["CreditCard","BankAccount","Wallet"].each do |payment_mode|
        #records = ObdxBmBillPayment.payment_mode_records(payment_mode,start_date,end_date)
        records = ["sdfdsf","sdfsdf"]
        csv_string = generate_csv("obdx_bill_desk_header", records, "billdesk")
        Zip::File.open("billdesk_report.zip", Zip::File::CREATE) {
          |zipfile|
          zipfile.get_output_stream("#{payment_mode}.csv"){|f| f.puts csv_string}
        }
        send_file "#{Rails.root}/billdesk_report.zip", :type => 'application/zip',
                             :disposition => 'attachment',
                             :filename => "billdesk_report.zip"
      end
      FileUtils.rm_rf('Rails.root}/billdesk_report.zip')     
    elsif report_type == 'wallet_bussiness'
      records = ObdxBmBillPayment.fetch_for_wallet_format(start_date, end_date)
      csv_string = generate_csv("obdx_wallet_header", records, "wallet")
      send_data csv_string, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=wallet_bussiness_csv_#{Time.now}.csv"
    else
      records = ObdxBmBillPayment.fetch_for_cc_format(start_date, end_date)
      csv_string = generate_csv("obdx_cc_header", records, 'credit_card')
      send_data csv_string, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=CreditCard_csv_#{Time.now}.csv"
    end

  end

  def generate_csv(header_name,records, binder_name)
    csv_string = CSV.generate do |csv|
      csv << send("#{header_name}")
      send("#{binder_name}_data_binder", records)
      array_records = billdesk_data_binder(records)
      array_records.each do |record|
        csv << record
      end
    end 
    return csv_string
  end

  def create_zip(csvs)
  end

  def obdx_bill_desk_header
    ['SourceID','Customer ID','Biller ID','Payment ID','Source Reference Number','Debit Ammount(RS.ps)','Trnasaction Date']
  end

  def obdx_wallet_header
    ["Transaction Date", "Merchant Reference Number",  "Transaction Amount", "Transaction Status"]
  end

  def obdx_cc_header
    ["Transaction Initiation Date", "Transaction Completion Date", "Transaction Amount", "Transaction Status", "Transaction Type", "Decline Code", "Decline Reason", "Transaction Reference", "CC Number[Masked]", "CC Account Number", "Customer ID", "Dealer Details", "Store ID", "Final Response FRom Biller", "Auth Code"]
  end

 def billdesk_data_binder(records)
  # data_arr = []
  # records.each do |record|
  #   data_arr << [record.sourceid, record.customer_id, record.biller_id, record.billpay_rep_ref, record.billpay_rep_ref, record.txn_amount, record.txn_date_time]
  # end
  data_arr = [["sdfdsf","esfsfdsf","sdfsdf","sdfsdfs","sdfsdf","sdfsdf","sdfsdf","sdfsdfds","sdfsdfs"]]
  
 end

 def wallet_data_binder(records)
  data_arr = []
  records.each do |record|
    success_records = record.obdx_bm_billpay_steps.where(step_name: 'WALLET_DEBITED', status_code: 'COMPLETED').last
    failure_records = record.obdx_bm_billpay_steps.where(step_name: 'WALLET_DEBIT', status_code: 'FAILED').last
    records_bill_pay_status = success_records.any? ? "SUCCESS" : failure_records.any? ? "FAILED" : ''
    data_arr << [record.txn_date_time, record.wallet_req_ref, record.txn_amount, record.step_name, records_bill_pay_status]
  end
 end

 def credit_card_data_binder(records)
  data_arr = []
  records.each do |record|
    approved_records = record.obdx_bm_billpay_steps.where(step_name: 'CREDIT_CARD_DEBITED', status_code: 'COMPLETED').last
    declined_records = record.obdx_bm_billpay_steps.where(step_name: 'CREDITCARD_DEBIT', status_code: 'FAILED').last
    records_cc_status = approved_records.any? ? "APPROVE" : declined_records.any? ? "DECLINE" : ''

    success_records = record.obdx_bm_billpay_steps.where(step_name: 'BILLPAY', status_code: 'COMPLETED').last
    failure_records = record.obdx_bm_billpay_steps.where(step_name: 'BILLPAY', status_code: 'FAILED').last
    records_bill_pay_status = success_records.any? ? "SUCCESS" : failure_records.any? ? "FAILED" : ''

    card_start_end_no = record.card_start + 'XXXXXX' + record.card_end

    data_arr << [record.req_timestamp, record.rep_timestamp, record.txn_amount, records_cc_status, record.transaction_type, record.fault_code, record.fault_reason, record.creditcard_req_ref, card_start_end_no, debit_account_no, record.customer_id, record.biller_id, record.store_id, records_bill_pay_status, record.auth_code]
  end
 end

end