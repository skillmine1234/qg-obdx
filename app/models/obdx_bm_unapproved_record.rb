class ObdxBmUnapprovedRecord < ActiveRecord::Base
  establish_connection "obdx_#{Rails.env}"	
  	
  belongs_to :obdx_bm_approvable, :polymorphic => true, :unscoped => true
  BM_TABLES = ['ObdxBmRule','ObdxBmBiller','ObdxBmAggregatorPayment','ObdxBmApp']
end