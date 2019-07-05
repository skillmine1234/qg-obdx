module ObdxBmUnapprovedRecordsHelper
  
  def filter_records(records)
    result = []
    ObdxBmUnapprovedRecord::BM_TABLES.each do |record|
      count = ObdxBmUnapprovedRecord.where("obdx_bm_approvable_type =?",record).count 
      result << {:record_type => record, :record_count => count}
    end
    result
  end
end