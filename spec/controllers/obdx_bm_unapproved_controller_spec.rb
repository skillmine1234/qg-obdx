require 'spec_helper'

describe ObdxBmUnapprovedRecordsController do
  include HelperMethods
  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
  end

  describe "GET index" do
    it "assigns all bm_unapproved_records as @bm_unapproved_records" do
      bm_unapproved_record = Factory(:bm_unapproved_record, :bm_approvable_type => 'BmRule')
      get :index
      assigns(:records).should eq([{:record_type=>"BmRule", :record_count=>1}, {:record_type=>"BmBiller", :record_count=>0}, {:record_type=>"BmAggregatorPayment", :record_count=>0}, {:record_type=>"BmApp", :record_count=>0}])
    end
  end
end
