module ObdxBmBillersHelper

  def find_bm_billers(params)
    bm_billers = ObdxBmBiller.all
    bm_billers = bm_billers.where("billerid=?",params[:billerid]) if params[:billerid].present?
    bm_billers = bm_billers.where("biller_name=?",params[:biller_mode]) if params[:biller_mode].present?
    bm_billers = bm_billers.where("biller_category=?",params[:biller_category]) if params[:biller_category].present?
    bm_billers = bm_billers.where("biller_name=?",params[:biller_name]) if params[:biller_name].present?
    bm_billers = bm_billers.where("biller_location=?",params[:biller_name]) if params[:biller_location].present?
    bm_billers = bm_billers.where("biller_type=?",params[:biller_type]) if params[:biller_type].present?
    bm_billers
  end

  def description_for_biller_type(value)
    case value
    when "T"
      "Presentment"
    when "P"
      "Payee"
    when "A"
      "Both"
    when "R"
      "Recharge"
    end
  end
end
