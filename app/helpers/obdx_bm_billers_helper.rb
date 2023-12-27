module ObdxBmBillersHelper

  def find_bm_billers(params)
    bm_billers = ObdxBmBiller.all
    bm_billers = bm_billers.where("LOWER(billerid) LIKE ?", "%#{params[:billerid].downcase}%") if params[:billerid].present?
    bm_billers = bm_billers.where("LOWER(biller_name) LIKE ?", "%#{params[:biller_name].downcase}%") if params[:biller_name].present?
    bm_billers = bm_billers.where("LOWER(biller_category) LIKE ?", "%#{params[:biller_category].downcase}%") if params[:biller_category].present?
    bm_billers = bm_billers.where("LOWER(biller_name) LIKE ?", "%#{params[:biller_name].downcase}%") if params[:biller_name].present?
    bm_billers = bm_billers.where("LOWER(biller_location) LIKE ?", "%#{params[:biller_location].downcase}%") if params[:biller_location].present?
    bm_billers = bm_billers.where("LOWER(biller_type) LIKE ?", "%#{params[:biller_type].downcase}%") if params[:biller_type].present?
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
