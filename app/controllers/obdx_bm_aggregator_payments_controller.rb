class ObdxBmAggregatorPaymentsController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  include ObdxBmAggregatorPaymentsHelper
  
  def new
    @bm_aggregator_payment = ObdxBmAggregatorPayment.new
  end

  def create
    @bm_aggregator_payment = ObdxBmAggregatorPayment.new(params[:bm_aggregator_payment])
    if !@bm_aggregator_payment.valid?
      render "new"
    else
      @bm_aggregator_payment.created_by = current_user.id
      @bm_aggregator_payment.save!
      
      flash[:alert] = 'Aggregator Payment successfully created and is pending for approval'
      redirect_to @bm_aggregator_payment
    end
  end 

  def edit
    bm_aggregator_payment = ObdxBmAggregatorPayment.unscoped.find_by_id(params[:id])
    if bm_aggregator_payment.approval_status == 'A' && bm_aggregator_payment.unapproved_record.nil?
      # params = (bm_aggregator_payment.attributes).merge({:approved_id => bm_aggregator_payment.id,:approved_version => bm_aggregator_payment.lock_version})
      # bm_aggregator_payment = BmAggregatorPayment.new(params)
      flash[:notice] = "You cannot edit this record as it is already approved!"
      redirect_to bm_aggregator_payments_path
    end
    @bm_aggregator_payment = bm_aggregator_payment   
  end

  def update
    @bm_aggregator_payment = ObdxBmAggregatorPayment.unscoped.find_by_id(params[:id])
    @bm_aggregator_payment.attributes = params[:bm_aggregator_payment]
    if !@bm_aggregator_payment.valid?
      render "edit"
    else
      @bm_aggregator_payment.updated_by = current_user.id
      @bm_aggregator_payment.save!
      flash[:alert] = 'Aggregator Payment successfully modified and is pending for approval'
      redirect_to @bm_aggregator_payment
    end
    rescue ActiveRecord::StaleObjectError
      @bm_aggregator_payment.reload
      flash[:alert] = 'Someone edited the aggregator payment the same time you did. Please re-apply your changes to the aggregator payment.'
      render "edit"
  end 

  def show
    @bm_aggregator_payment = ObdxBmAggregatorPayment.unscoped.find_by_id(params[:id])
  end

  def index
    if params[:advanced_search].present?
      bm_aggregator_payments = find_bm_aggregator_payments(params).order("id desc")
    else
      bm_aggregator_payments = (params[:approval_status].present? and params[:approval_status] == 'U') ? BmAggregatorPayment.unscoped.where("approval_status =?",'U').order("id desc") : BmAggregatorPayment.order("id desc")
    end
    @bm_aggregator_payments_count = bm_aggregator_payments.count
    @bm_aggregator_payments = bm_aggregator_payments.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def audit_logs
    @bm_aggregator_payment = ObdxBmAggregatorPayment.unscoped.find(params[:id]) rescue nil
    @audit = @bm_aggregator_payment.audits[params[:version_id].to_i] rescue nil
  end
  
  def approve
    @bm_aggregator_payment = ObdxBmAggregatorPayment.unscoped.find(params[:id]) rescue nil
    ObdxBmAggregatorPayment.transaction do
      approval = @bm_aggregator_payment.approve
      if @bm_aggregator_payment.save and approval.empty?
        flash[:alert] = "BmAggregatorPayment record was approved successfully"
        redirect_to hit_api_path(:id => @bm_aggregator_payment.id)
      else
        msg = approval.empty? ? @bm_aggregator_payment.errors.full_messages : @bm_aggregator_payment.errors.full_messages << approval
        flash[:alert] = msg
        raise ActiveRecord::Rollback
        redirect_to @bm_aggregator_payment
      end
    end
  end
  
  def hit_api
    @bm_aggregator_payment = ObdxBmAggregatorPayment.find(params[:id]) rescue nil
    api_req_url = ENV['CONFIG_URL_BM_AGGR_PAYMENT']

    conn = Faraday.new(:url => api_req_url, :ssl => {:verify => false}) do |c|
      c.use Faraday::Request::UrlEncoded
      c.use Faraday::Response::Logger
      c.use Faraday::Adapter::NetHttp
    end
    response = conn.post "#{api_req_url}/?id=#{@bm_aggregator_payment.id}"
    status_code = response.env.status
    flash[:alert] = "Api was hit and Status code of response is #{status_code}"
    redirect_to @bm_aggregator_payment
  end
  
  def destroy
    bm_aggregator_payment = ObdxBmAggregatorPayment.unscoped.delete(params[:id])
    unapproved_record = ObdxBmUnapprovedRecord.find_by(:bm_approvable_id => params[:id]).delete
    flash[:alert] = "BmAggregatorPayment record has been deleted!"
    redirect_to bm_aggregator_payments_path
  end
  
  private

  def bm_aggregator_payment_params
    params.require(:bm_aggregator_payment).permit(:cod_acct_no, :neft_sender_ifsc, :bene_acct_no, :bene_acct_ifsc, :payment_amount, 
                                                  :lock_version, :approval_status, :last_action, :approved_version, 
                                                  :approved_id, :status, :fault_code, :fault_reason, :neft_req_ref, :neft_attempt_no, 
                                                  :neft_attempt_at, :neft_rep_ref, :neft_completed_at, :bene_name, :customer_id, :service_id, 
                                                  :rmtr_name, :rmtr_to_bene_note, :created_by, :updated_by,:neft_sender_account)

  end
end
