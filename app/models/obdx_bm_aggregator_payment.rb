class ObdxBmAggregatorPayment < ActiveRecord::Base
  #establish_connection "obdx_#{Rails.env}"
  
  alias_attribute :cod_acct_no,:pool_account
  alias_attribute :bene_acct_no,:benfficiary_account_number
  alias_attribute :bene_acct_ifsc,:benfficiary_account_ifsc

  include Approval
  include ObdxBmApproval

  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  has_one :bm_audit_log, :as => :bm_auditable
  
  validate :check_approval_status, :on => :create
  
  validates_presence_of :cod_acct_no, :neft_sender_ifsc, :bene_acct_no, :bene_acct_ifsc, :status, :bene_name, :customer_id, :payment_amount, :rmtr_name, :rmtr_to_bene_note

  def self.form_values(attribute)
    case attribute
    when "cod_acct_no"
      BmRule.first.cod_acct_no
    when "bene_acct_no"
      BmRule.first.bene_acct_no
    when "customer_id"
      BmRule.first.customer_id
    when "bene_acct_ifsc"
      BmRule.first.bene_account_ifsc
    when "neft_sender_ifsc"
      BmRule.first.neft_sender_ifsc
    when "service_id"
      ''
    end
  end
  
  def check_approval_status
    if self.approval_status == 'U' and self.approved_record.present?
      errors[:base] << "You cannot edit this record as it is already approved!"
    end
  end
end