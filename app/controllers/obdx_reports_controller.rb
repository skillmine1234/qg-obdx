class ObdxReportsController < ApplicationController
  # #authorize_resource
  before_action :authenticate_user!
  before_action :block_inactive_user!
  respond_to :json
  require 'fileutils'

  require 'csv'
  include ApplicationHelper

  def index
  end

  def html_report
    @records = generate_report(params[:report_type],params[:from_date],params[:to_date],"html_format")
    @report_type = params[:report_type]
    @start_date = params[:from_date]
    @end_date = params[:to_date]
    @table_header = table_header(params[:report_type])
    @column_reader = column_decider(params[:report_type])
  end

 def csv_reports
  generate_report(params[:report_type],params[:from_date],params[:to_date],"csv_format")
 end


 def table_header(report_type)
  if report_type == "bill_desk_credit_card" || report_type == "bill_desk_bank_account" || report_type == "bill_desk_wallet"
    return obdx_bill_desk_header
  elsif report_type == "wallet_bussiness"
    return obdx_wallet_header
  elsif report_type == "credit_card_bussiness"
     return obdx_cc_header
  end    
 end

def column_decider(report_type)
  if report_type == "bill_desk_credit_card" || report_type == "bill_desk_bank_account" || report_type == "bill_desk_wallet"
    ["sourceid","customer_id","biller_id","billpay_rep_ref","billpay_rep_ref","txn_amount","txn_date_time"]
  elsif report_type == "wallet_bussiness"
    ["txn_date_time","wallet_req_ref","txn_amount","step_name", "records_bill_pay_status"]
  elsif report_type == "credit_card_bussiness"
    ["req_timestamp", "rep_timestamp", "txn_amount", "cc_status", "transaction_type", "fault_code", "fault_reason", "creditcard_req_ref", "card_start_end_no", "debit_account_no", "customer_id","biller_id", "store_id", "records_bill_pay_status", "auth_code"]
  end    
end


  def generate_report(report_type,start_date=nil,end_date=nil,report_format)
    
      if report_type == "bill_desk_credit_card"
            records = ObdxBmBillPayment.payment_mode_records("CreditCard",start_date,end_date)
            if report_format == "html_format"
              return records
            else
              csv_string = generate_csv("obdx_bill_desk_header", records, "billdesk")
              send_data csv_string, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=bill_desk_credit_card#{Time.now}.csv"
            end
      elsif report_type == "bill_desk_bank_account"
            records = ObdxBmBillPayment.payment_mode_records("BankAccount",start_date,end_date)
            if report_format == "html_format"
              return records
             else
                csv_string = generate_csv("obdx_bill_desk_header", records, "billdesk")
                send_data csv_string, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=bill_desk_bank_account#{Time.now}.csv"
             end 
      elsif report_type == "bill_desk_wallet"
            records = ObdxBmBillPayment.payment_mode_records("Wallet",start_date,end_date)
            if report_format == "html_format"
              return records
            else  
              csv_string = generate_csv("obdx_bill_desk_header", records, "billdesk")
              send_data csv_string, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=bill_desk_wallet#{Time.now}.csv"                     
            end  
      elsif report_type == 'wallet_bussiness'
          records = ObdxBmBillPayment.fetch_for_wallet_format(start_date, end_date)
          if report_format == "html_format"
            return records
          else  
            csv_string = generate_csv("obdx_wallet_header", records, "wallet")
            send_data csv_string, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=wallet_bussiness_csv_#{Time.now}.csv"
          end  
      else
          records = ObdxBmBillPayment.fetch_for_cc_format(start_date, end_date)
          if report_format == "html_format"
            return records
          else
            csv_string = generate_csv("obdx_cc_header", records, 'credit_card')
          send_data csv_string, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=CreditCard_csv_#{Time.now}.csv"
          end
      end
  end

  def generate_csv(header_name,records, binder_name)
    csv_string = CSV.generate do |csv|
      csv << send("#{header_name}")
      array_records =  send("#{binder_name}_data_binder", records)
      array_records.each do |record|
        csv << record
      end
    end 
    return csv_string
  end

  def obdx_bill_desk_header
    ['SourceID','Customer ID','Biller ID','Payment ID','Source Reference Number','Debit Ammount(Rs.ps)','Trnasaction Date']
  end

  def obdx_wallet_header
    ["Transaction Date", "Merchant Reference Number",  "Transaction Amount", "Transaction Status"]
  end

  def obdx_cc_header
    ["Transaction Initiation Date", "Transaction Completion Date", "Transaction Amount", "Transaction Status", "Transaction Type", "Decline Code", "Decline Reason", "Transaction Reference", "CC Number[Masked]", "CC Account Number", "Customer ID", "Dealer Details", "Store ID", "Final Response FRom Biller", "Auth Code"]
  end


 def billdesk_data_binder(records)
   data_arr = []
  final_arr = []
   records.each do |record|
     data_arr << [record.sourceid, record.customer_id, record.biller_id, record.billpay_rep_ref, record.billpay_rep_ref, record.txn_amount, record.txn_date_time]
   end
   return data_arr
 end

 def wallet_data_binder(records)
  data_arr = []
  records.each do |record|
    records_bill_pay_status = record.records_bill_pay_status
    data_arr << [record.txn_date_time, record.wallet_req_ref, record.txn_amount, record.step_name, records_bill_pay_status]
  end
 end

 def credit_card_data_binder(records)
  data_arr = []
  records.each do |record|
    records_cc_status = record.records_cc_status
    records_bill_pay_status = record.records_bill_pay_status
    card_start_end_no = record.card_start_end_no
    data_arr << [record.req_timestamp, record.rep_timestamp, record.txn_amount, records_cc_status, record.transaction_type, record.fault_code, record.fault_reason, record.creditcard_req_ref, card_start_end_no, record.debit_account_no, record.customer_id, record.biller_id, record.store_id, records_bill_pay_status, record.auth_code]
  end
 end

end