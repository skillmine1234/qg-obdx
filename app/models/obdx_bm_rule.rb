class ObdxBmRule < ActiveRecord::Base
  establish_connection "obdx_#{Rails.env}"
  self.table_name = "bm_rules"
  self.sequence_name = "bm_rules_seq"
  
  PAYMENT_MODE = ["CASA","CC","Wallet"]
  
  include Approval
  include ObdxBmApproval

  belongs_to :created_user, :foreign_key => 'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key => 'updated_by', :class_name => 'User'
  
  validates_uniqueness_of :app_id, scope: [:approval_status]
  
  validates_presence_of :app_id, on: :create, if: "(approved_record.nil?) || (approved_record.app_id.present?)"
  validates_presence_of :app_id, on: :update, unless: "app_id_was.blank?"

  validates_presence_of :aggregate_cod_acct_no, :customer_id, :bene_account_no, :bene_account_ifsc, :neft_sender_ifsc, :lock_version, :approval_status, :source_id, :traceid_prefix
  validates :aggregate_cod_acct_no, :bene_account_no, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => "Invalid format, expected format is : {[a-z|A-Z|0-9]}" }, length: {maximum: 16, minimum: 1}
  validates :customer_id, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => "Invalid format, expected format is : {[a-z|A-Z|0-9]}" }, length: {maximum: 15, minimum: 1}
  validates :bene_account_ifsc, :neft_sender_ifsc, format: {with: /\A[A-Z]{4}[0][0-9]{6}+\z/, :message => "Invalid format, expected format is : {[A-Z]{4}[0][0-9]{6}}" }
  validates :app_id, length: { maximum: 50 }, allow_blank: true
end
