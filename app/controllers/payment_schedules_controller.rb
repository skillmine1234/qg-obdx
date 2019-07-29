class PaymentSchedulesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper

  def index
  end

  def auto

  end

  def schedule
    
  end
 
end
