class ObdxBmAppsController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper
  include ObdxBmAppsHelper
  
  def new
    @bm_app = ObdxBmApp.new
  end

  def create
    @bm_app = ObdxBmApp.new(params[:obdx_bm_app])
    if !@bm_app.valid?
      render "new"
    else
      @bm_app.created_by = current_user.id
      @bm_app.save!
      flash[:alert] = 'Bm App successfully created and is pending for approval'
      redirect_to @bm_app
    end
  end 

  def edit
    bm_app = ObdxBmApp.unscoped.find_by_id(params[:id])
    if bm_app.approval_status == 'A' && bm_app.unapproved_record.nil?
      params = (bm_app.attributes).merge({:approved_id => bm_app.id,:approved_version => bm_app.lock_version})
      bm_app = ObdxBmApp.new(params)
    end
    @bm_app = bm_app   
  end

  def update
    @bm_app = ObdxBmApp.unscoped.find_by_id(params[:id])
    @bm_app.attributes = params[:obdx_bm_app]
    if !@bm_app.valid?
      render "edit"
    else
      @bm_app.updated_by = current_user.id
      @bm_app.save!
      flash[:alert] = 'Bm App successfully modified and is pending for approval'
      redirect_to @bm_app
    end
    rescue ActiveRecord::StaleObjectError
      @bm_app.reload
      flash[:alert] = 'Someone edited the bm_app the same time you did. Please re-apply your changes to the bm_app.'
      render "edit"
  end 

  def show
    @bm_app = ObdxBmApp.unscoped.find_by_id(params[:id])
  end

  def index
    if params[:advanced_search].present?
      bm_apps = find_bm_apps(params).order("id desc")
    else
      bm_apps = (params[:approval_status].present? and params[:approval_status] == 'U') ? ObdxBmApp.unscoped.where("approval_status =?",'U').order("id desc") : ObdxBmApp.order("id desc")
    end
    @bm_apps_count = bm_apps.count
    @bm_apps = bm_apps.paginate(:per_page => 10, :page => params[:page]) rescue []
  end

  def audit_logs
    @bm_app = ObdxBmApp.unscoped.find(params[:id]) rescue nil
    @audit = @bm_app.audits[params[:version_id].to_i] rescue nil
  end
  
  def approve
    @bm_app = ObdxBmApp.unscoped.find(params[:id]) rescue nil
    ObdxBmApp.transaction do
      approval = @bm_app.approve
      if @bm_app.save and approval.empty?
        flash[:alert] = "BmApp record was approved successfully"
      else
        msg = approval.empty? ? @bm_app.errors.full_messages : @bm_app.errors.full_messages << approval
        flash[:alert] = msg
        raise ActiveRecord::Rollback
      end
    end
    redirect_to @bm_app
  end
  
  private

  def obdx_bm_app_params
    params.require(:obdx_bm_app).permit(:app_id, :channel_id, :lock_version, :approval_status, :last_action, :approved_version, 
                                   :approved_id, :created_by, :updated_by, :needs_otp)
  end
end
