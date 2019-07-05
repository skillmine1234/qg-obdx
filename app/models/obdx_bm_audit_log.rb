class ObdxBmAuditLog < ActiveRecord::Base
  self.table_name = "bm_audit_logs"	
  belongs_to :obdx_bm_auditable, :polymorphic => true
end