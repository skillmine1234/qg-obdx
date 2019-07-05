require 'will_paginate/array'

class ObdxBmBillPaymentsSummariesController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  
  def index
    bm_bill_payments = ObdxBmBillPayment.order("id desc")
    @bm_bill_payments_summary = ObdxBmBillPayment.group(:status, :pending_approval).count(:id)
    @bm_bill_payments_statuses = ObdxBmBillPayment.group(:status).count(:id).keys
    @total_pending_records = ObdxBmBillPayment.where(:pending_approval => 'Y').count(:id)
    @total_records = ObdxBmBillPayment.count(:id)
  end
end