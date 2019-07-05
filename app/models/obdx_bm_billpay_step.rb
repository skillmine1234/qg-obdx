class ObdxBmBillpayStep < ActiveRecord::Base
  #establish_connection "obdx_#{Rails.env}"
  self.table_name = "bm_biller_steps"
  belongs_to :obdx_bm_bill_payment

  validates_presence_of :bm_bill_payment_id, :step_no, :attempt_no, :step_name, :status_code

end