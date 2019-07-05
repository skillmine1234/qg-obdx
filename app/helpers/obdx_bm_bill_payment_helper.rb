module ObdxBmBillPaymentHelper

  def find_logs(params,transaction)
    if params[:step_name] != 'ALL'
      transaction.bm_billpay_steps.where('step_name=?',params[:step_name]).order("attempt_no desc") rescue []
    else
      transaction.bm_billpay_steps.order("id desc") rescue []
    end      
  end

  def payment_summary_count(status_hash,key)
    count = status_hash[key] rescue 0
    count.nil? ? 0 : count
  end

end