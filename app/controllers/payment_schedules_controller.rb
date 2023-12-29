class PaymentSchedulesController < ApplicationController
  
  before_action :authenticate_user!
  before_action :block_inactive_user!
  respond_to :json
  include ApplicationHelper

  def index
  end

  def auto

  end

  def schedule
    
  end
 
end
