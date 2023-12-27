module ObdxBmAggregatorPaymentsHelper
  def find_bm_aggregator_payments(params)
    aggregator_payments = (params[:approval_status].present? and params[:approval_status] == 'U') ? ObdxBmAggregatorPayment.unscoped : BmAggregatorPayment
    aggregator_payments = aggregator_payments.where("LOWER(bm_aggregator_payments.status) LIKE ?", "%#{params[:status].downcase}%").split(",").collect(&:strip)) if params[:status].present?
    aggregator_payments = aggregator_payments.where("LOWER(bm_aggregator_payments.cod_acct_no) LIKE ?", "%#{params[:cod_acct_no].downcase}%").split(",").collect(&:strip)) if params[:cod_acct_no].present?
    aggregator_payments = aggregator_payments.where("LOWER(bm_aggregator_payments.neft_sender_ifsc) LIKE ?", "%#{params[:neft_sender_ifsc].downcase}%").split(",").collect(&:strip)) if params[:neft_sender_ifsc].present?
    aggregator_payments = aggregator_payments.where("LOWER(bm_aggregator_payments.bene_acct_no) LIKE ?", "%#{params[:bene_acct_no].downcase}%").split(",").collect(&:strip)) if params[:bene_acct_no].present?
    aggregator_payments = aggregator_payments.where("LOWER(bm_aggregator_payments.bene_acct_ifsc) LIKE ?", "%#{params[:bene_acct_ifsc].downcase}%").split(",").collect(&:strip)) if params[:bene_acct_ifsc].present?
    aggregator_payments
  end
end
