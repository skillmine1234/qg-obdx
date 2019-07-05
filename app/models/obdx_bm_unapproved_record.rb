class ObdxBmUnapprovedRecord < ActiveRecord::Base
  #establish_connection "obdx_#{Rails.env}"	
  self.table_name = "obdx_bm_unapproved_records"	
  belongs_to :obdx_bm_approvable, :polymorphic => true, :unscoped => true
  BM_TABLES = ['ObdxBmRule','ObdxBmBiller','ObdxBmAggregatorPayment','ObdxBmApp']
end