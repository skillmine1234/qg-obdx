require 'spec_helper'

describe ObdxBmRulesController do
  include HelperMethods
  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
  end

  describe "GET new" do
    it "assigns a new bm_rule as @bm_rule" do
      get :new
      assigns(:bm_rule).should be_a_new(BmRule)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new bm_rule" do
        params = Factory.attributes_for(:bm_rule)
        expect {
          post :create, {:bm_rule => params}
        }.to change(BmRule.unscoped, :count).by(1)
        flash[:alert].should  match(/Rule successfully created/)
        response.should be_redirect
      end

      it "assigns a newly created bm_rule as @bm_rule" do
        params = Factory.attributes_for(:bm_rule)
        post :create, {:bm_rule => params}
        assigns(:bm_rule).should be_a(BmRule)
        assigns(:bm_rule).should be_persisted
      end

      it "redirects to the created bm_rule" do
        params = Factory.attributes_for(:bm_rule)
        post :create, {:bm_rule => params}
        response.should redirect_to(BmRule.unscoped.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bm_rule as @bm_rule" do
        params = Factory.attributes_for(:bm_rule)
        params[:cod_acct_no] = nil
        expect {
          post :create, {:bm_rule => params}
        }.to change(BmRule, :count).by(0)
        assigns(:bm_rule).should be_a(BmRule)
        assigns(:bm_rule).should_not be_persisted
      end

      it "re-renders the 'new' template when show_errors is true" do
        params = Factory.attributes_for(:bm_rule)
        params[:cod_acct_no] = nil
        post :create, {:bm_rule => params}
        response.should render_template("new")
      end
    end
  end

  describe "GET index" do
    it "assigns all bm_rules with approval_status 'A' as @bm_rules" do
      bm_rule1 = Factory(:bm_rule, :approval_status => 'A')
      bm_rule2 = Factory(:bm_rule, :approval_status => 'U')
      get :index
      assigns(:bm_rules).should eq([bm_rule1])
    end
    
    it "assigns all bm_rules with approval_status 'U' as @bm_rules" do
      bm_rule1 = Factory(:bm_rule, :approval_status => 'A')
      bm_rule2 = Factory(:bm_rule, :approval_status => 'U')
      get :index, approval_status: 'U'
      assigns(:bm_rules).should eq([bm_rule2])
    end
  end

  describe "GET show" do
    it "assigns the requested rule as @bm_rule" do
      bm_rule = Factory(:bm_rule)
      get :show, {:id => bm_rule.id}
      assigns(:bm_rule).should eq(bm_rule)
    end
  end
  
  describe "GET edit" do
    it "assigns the requested rule as @bm_rule" do
      bm_rule = Factory(:bm_rule)
      get :edit, {:id => bm_rule.id}
      assigns(:bm_rule).should eq(bm_rule)
    end

    it "assigns the requested bm_rule with status 'A' as @bm_rule" do
      bm_rule = Factory(:bm_rule,:approval_status => 'A')
      get :edit, {:id => bm_rule.id}
      assigns(:bm_rule).should eq(bm_rule)
    end

    it "assigns the new bm_rule with requested bm_rule params when status 'A' as @bm_rule" do
      bm_rule = Factory(:bm_rule,:approval_status => 'A')
      params = (bm_rule.attributes).merge({:approved_id => bm_rule.id,:approved_version => bm_rule.lock_version})
      get :edit, {:id => bm_rule.id}
      assigns(:bm_rule).should eq(BmRule.new(params))
    end
  end
  
  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested rule" do
        bm_rule = Factory(:bm_rule, :cod_acct_no => "AABBCCDD0011")
        params = bm_rule.attributes.slice(*bm_rule.class.attribute_names)
        params[:cod_acct_no] = "CCBBAADD0011"
        put :update, {:id => bm_rule.id, :bm_rule => params}
        bm_rule.reload
        bm_rule.cod_acct_no.should == "CCBBAADD0011"
      end

      it "assigns the requested rule as @bm_rule" do
        bm_rule = Factory(:bm_rule, :cod_acct_no => "AABBCCDD0011")
        params = bm_rule.attributes.slice(*bm_rule.class.attribute_names)
        params[:cod_acct_no] = "CCBBAADD0011"
        put :update, {:id => bm_rule.to_param, :bm_rule => params}
        assigns(:bm_rule).should eq(bm_rule)
      end

      it "redirects to the rule" do
        bm_rule = Factory(:bm_rule, :cod_acct_no => "AABBCCDD0011")
        params = bm_rule.attributes.slice(*bm_rule.class.attribute_names)
        params[:cod_acct_no] = "CCBBAADD0011"
        put :update, {:id => bm_rule.to_param, :bm_rule => params}
        response.should redirect_to(bm_rule)
      end

      it "should raise error when tried to update at same time by many" do
        bm_rule = Factory(:bm_rule, :cod_acct_no => "ABCDEFGH0123")
        
        # update once
        params = bm_rule.attributes.slice(*bm_rule.class.attribute_names)
        params[:cod_acct_no] = "0123ABCDEFGH"
        put :update, {:id => bm_rule.id, :bm_rule => params}

        # update another time, without a reload, this will fail as the lock_version has changed 
        params = bm_rule.attributes.slice(*bm_rule.class.attribute_names)
        params[:cod_acct_no] = "1234ABCDEFGH"
        put :update, {:id => bm_rule.id, :bm_rule => params}
        flash[:alert].should  match(/Someone edited the rule the same time you did. Please re-apply your changes to the rule/)
      end
    end
  end

  describe "GET audit_logs" do
    it "assigns the requested rule as @bm_rule" do
      bm_rule = Factory(:bm_rule)
      get :audit_logs, {:id => bm_rule.id, :version_id => 0}
      assigns(:bm_rule).should eq(bm_rule)
      assigns(:audit).should eq(bm_rule.audits.first)
      get :audit_logs, {:id => 12345, :version_id => "b"}
      assigns(:bm_rule).should eq(nil)
      assigns(:audit).should eq(nil)
    end
  end

  describe "PUT approve" do
    it "(edit) unapproved record can be approved and old approved record will be updated" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      bm_rule1 = Factory(:bm_rule, :approval_status => 'A')
      bm_rule2 = Factory(:bm_rule, :approval_status => 'U', :cod_acct_no => '09789654321', :approved_version => bm_rule1.lock_version, :approved_id => bm_rule1.id, :created_by => 666)
      # the following line is required for reload to get triggered (TODO)
      bm_rule1.approval_status.should == 'A'
      BmUnapprovedRecord.count.should == 1
      put :approve, {:id => bm_rule2.id}
      BmUnapprovedRecord.count.should == 0
      bm_rule1.reload
      bm_rule1.cod_acct_no.should == '09789654321'
      bm_rule1.updated_by.should == "666"
      BmRule.find_by_id(bm_rule2.id).should be_nil
    end

    it "(create) unapproved record can be approved" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      bm_rule = Factory(:bm_rule, :cod_acct_no => '09789654321', :approval_status => 'U')
      BmUnapprovedRecord.count.should == 1
      put :approve, {:id => bm_rule.id}
      BmUnapprovedRecord.count.should == 0
      bm_rule.reload
      bm_rule.cod_acct_no.should == '09789654321'
      bm_rule.approval_status.should == 'A'
    end
  end
end
