module ObdxBmAggregatorPaymentsHelper
  def find_bm_aggregator_payments(params)
    aggregator_payments = (params[:approval_status].present? and params[:approval_status] == 'U') ? ObdxBmAggregatorPayment.unscoped : BmAggregatorPayment
    aggregator_payments = aggregator_payments.where("bm_aggregator_payments.status=?",params[:status]) if params[:status].present?
    aggregator_payments = aggregator_payments.where("bm_aggregator_payments.cod_acct_no=?",params[:cod_acct_no]) if params[:cod_acct_no].present?
    aggregator_payments = aggregator_payments.where("bm_aggregator_payments.neft_sender_ifsc=?",params[:neft_sender_ifsc]) if params[:neft_sender_ifsc].present?
    aggregator_payments = aggregator_payments.where("bm_aggregator_payments.bene_acct_no=?",params[:bene_acct_no]) if params[:bene_acct_no].present?
    aggregator_payments = aggregator_payments.where("bm_aggregator_payments.payment_amount>=? and bm_aggregator_payments.payment_amount <=?",params[:from_amount].to_f,params[:to_amount].to_f) if params[:to_amount].present? and params[:from_amount].present?
    aggregator_payments = aggregator_payments.where("bm_aggregator_payments.bene_acct_ifsc=?",params[:bene_account_ifsc]) if params[:bene_account_ifsc].present?
    aggregator_payments = aggregator_payments.where("bm_aggregator_payments.created_at>=? and bm_aggregator_payments.created_at<=?",Time.zone.parse(params[:from_date]).beginning_of_day,Time.zone.parse(params[:to_date]).end_of_day) if params[:from_date].present? and params[:to_date].present?
    aggregator_payments
  end
end
