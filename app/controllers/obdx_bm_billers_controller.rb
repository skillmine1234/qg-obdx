class ObdxBmBillersController < ApplicationController
  #authorize_resource
  before_action :authenticate_user!
  before_action :block_inactive_user!
  respond_to :json

  include ApplicationHelper
  include ObdxBmBillersHelper
  
  def new
    @bm_biller = ObdxBmBiller.new
  end

  def create
    @bm_biller = ObdxBmBiller.new(params[:bm_biller])
    if !@bm_biller.valid?
      render "new"
    else
      @bm_biller.created_by = current_user.id
      @bm_biller.save!
      flash[:alert] = "Biller successfully #{@bm_biller.approved_id.nil? ? 'created' : 'updated'} and is pending for approval"
      redirect_to @bm_biller
    end
  end 

  def edit
    bm_biller = ObdxBmBiller.unscoped.find_by_id(params[:id])
    if bm_biller.approval_status == 'A' && bm_biller.unapproved_record.nil?
      params = (bm_biller.attributes).merge({:approved_id => bm_biller.id,:approved_version => bm_biller.lock_version})
      bm_biller = ObdxBmBiller.new(params)
    end
    @bm_biller = bm_biller   
  end

  def update
    @bm_biller = ObdxBmBiller.unscoped.find_by_id(params[:id])
    @bm_biller.attributes = params[:bm_biller]
    if !@bm_biller.valid?
      render "edit"
    else
      @bm_biller.updated_by = current_user.id
      @bm_biller.save!
      flash[:alert] = 'Biller successfully modified and is pending for approval'
      redirect_to @bm_biller
    end
    rescue ActiveRecord::StaleObjectError
      @bm_biller.reload
      flash[:alert] = 'Someone edited the biller the same time you did. Please re-apply your changes to the biller.'
      render "edit"
  end 

  def show
    @bm_biller = ObdxBmBiller.find_by_id(params[:id])
  end

  def index
    if params[:advanced_search].present?
      bm_billers = find_bm_billers(params).order("id desc")
    else
      bm_billers = ObdxBmBiller.all.order("id desc")
    end
    @bm_billers_count = bm_billers.count
    @bm_billers = bm_billers.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def audit_logs
    @bm_biller = ObdxBmBiller.unscoped.find(params[:id]) rescue nil
    @audit = @bm_biller.audits[params[:version_id].to_i] rescue nil
  end
  
  def approve
    @bm_biller = ObdxBmBiller.unscoped.find(params[:id]) rescue nil
    ObdxBmBiller.transaction do
      approval = @bm_biller.approve
      if @bm_biller.save and approval.empty?
        flash[:alert] = "BmBiller record was approved successfully"
      else
        msg = approval.empty? ? @bm_biller.errors.full_messages : @bm_biller.errors.full_messages << approval
        flash[:alert] = msg
        raise ActiveRecord::Rollback
      end
    end
    redirect_to @bm_biller
  end

  private

  def bm_biller_params
    params.require(:bm_biller).permit(:biller_code, :biller_name, :biller_category, :biller_location, :processing_method, 
                                      :is_enabled, :num_params, :param1_name, :param1_pattern, :param1_tooltip, :param2_name,
                                      :param2_pattern, :param2_tooltip, :param3_name, :param3_pattern, :param3_tooltip, 
                                      :param4_name, :param4_pattern, :param4_tooltip, :param5_name, :param5_pattern, 
                                      :param5_tooltip, :partial_pay, :lock_version, :approval_status, :last_action, :approved_version, 
                                      :approved_id, :created_by, :updated_by)
  end

end