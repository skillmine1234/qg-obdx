module ObdxBmApproval  
  extend ActiveSupport::Concern
  included do
    has_one :obdx_bm_unapproved_record, :as => :obdx_bm_approvable

    after_create :on_create_create_bm_unapproved_record
    after_destroy :on_destory_remove_bm_unapproved_records
    after_update :on_update_remove_bm_unapproved_records
  end

  def on_create_create_bm_unapproved_record
    if approval_status == 'U'
      ObdxBmUnapprovedRecord.create!(:obdx_bm_approvable => self)
    end
  end
  
  def on_destory_remove_bm_unapproved_records
    if approval_status == 'U'
      obdx_bm_unapproved_record.delete
    end
  end
  
  def on_update_remove_bm_unapproved_records
    if approval_status == 'A' and approval_status_was == 'U'
      obdx_bm_unapproved_record.delete
    end
  end 
end