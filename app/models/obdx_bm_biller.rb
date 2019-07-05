class ObdxBmBiller < ActiveRecord::Base
  #establish_connection "obdx_#{Rails.env}"
  #self.table_name = "biller_details"
  self.table_name = "bm_billers"

  #include Approval
  #include BmApproval
  
  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'
  
  validates_presence_of :biller_code, :biller_name, :biller_category, :biller_location, :processing_method, :is_enabled, :num_params
  
  validates_uniqueness_of :biller_code, :scope => :approval_status
  
  validates :biller_code, format: {with: /\A[a-z|A-Z|0-9]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9]}' }
  validates :biller_name, :biller_location, format: {with: /\A[a-z|A-Z|0-9\s]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9\s]}' }
  validates :param1_name, :param2_name, :param3_name, :param4_name, :param5_name, format: {with: /\A[a-z|A-Z|0-9|\(|\)|\/|\.\s]+\z/, :message => 'Invalid format, expected format is : {[a-z|A-Z|0-9|\(|\)|\.\s]}'}, :allow_blank =>true
  
  validate :param_name_and_param_value
  
  def self.options_for_processing_method
    [['Presentment','T'],['Payee','P'],['Both','A'],['Recharge','R']]
  end
  
  def param_name_and_param_value
    if self.num_params == 1 and (self.param1_name.empty? || self.param1_pattern.empty?)
      errors[:base] << "Param Name and Pattern are mandatory for Param1 if Number of Parameters = 1"
    elsif self.num_params == 2 and (self.param1_name.empty? || self.param1_pattern.empty? || self.param2_name.empty? || self.param2_pattern.empty?)
      errors[:base] << "Param Name and Pattern are mandatory for Param1 and Param2 if Number of Parameters = 2"
    elsif self.num_params == 3 and (self.param1_name.empty? || self.param1_pattern.empty? || self.param2_name.empty? || self.param2_pattern.empty? || self.param3_name.empty? || self.param3_pattern.empty?)
      errors[:base] << "Param Name and Pattern are mandatory for Param1,Param2 & Param3 if Number of Parameters = 3"
    elsif self.num_params == 4 and (self.param1_name.empty? || self.param1_pattern.empty? || self.param2_name.empty? || self.param2_pattern.empty? || self.param3_name.empty? || self.param3_pattern.empty? || self.param4_name.empty? || self.param4_pattern.empty?)
      errors[:base] << "Param Name and Pattern are mandatory for Param1, Param2, Param3 and Param4 if Number of Parameters = 4"
    elsif self.num_params == 5 and (self.param1_name.empty? || self.param1_pattern.empty? || self.param2_name.empty? || self.param2_pattern.empty? || self.param3_name.empty? || self.param3_pattern.empty? || self.param4_name.empty? || self.param4_pattern.empty? || self.param5_name.empty? || self.param5_pattern.empty?)
      errors[:base] << "Param Name and Pattern are mandatory for Param1, Param2, Param3, Param4 and Param5 if Number of Parameters = 5"
    end
  end
end