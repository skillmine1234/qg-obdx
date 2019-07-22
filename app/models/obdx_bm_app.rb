class ObdxBmApp < ActiveRecord::Base 
  establish_connection "obdx_#{Rails.env}"
  self.table_name = "bm_apps"
  self.sequence_name = "bm_apps_seq"

  
  include Approval
  include ObdxBmApproval
  
  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  
  validates_presence_of :app_id, :channel_id, :needs_otp
  
  validates_uniqueness_of :app_id, :scope => :approval_status
end