require 'spec_helper'

describe ObdxBmBillersController do
  include HelperMethods
  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
  end

  describe "GET index" do
    it "assigns all bm_billers as @bm_billers" do
      bm_biller = Factory(:bm_biller, :approval_status => 'A')
      get :index
      assigns(:bm_billers).should eq([bm_biller])
    end

    it "assigns all unapproved bm_billers as @bm_billers when approval_status is passed" do
      bm_biller = Factory(:bm_biller, :approval_status => 'U')
      get :index, :approval_status => 'U'
      assigns(:bm_billers).should eq([bm_biller])
    end
  end

  describe "GET show" do
    it "assigns the requested bm_biller as @bm_biller" do
      bm_biller = Factory(:bm_biller)
      get :show, {:id => bm_biller.id}
      assigns(:bm_biller).should eq(bm_biller)
    end
  end

  describe "GET new" do
    it "assigns a new bm_biller as @bm_biller" do
      get :new
      assigns(:bm_biller).should be_a_new(BmBiller)
    end
  end

  describe "GET edit" do
    it "assigns the requested bm_biller with status 'U' as @bm_biller" do
      bm_biller = Factory(:bm_biller, :approval_status => 'U')
      get :edit, {:id => bm_biller.id}
      assigns(:bm_biller).should eq(bm_biller)
    end

    it "assigns the requested bm_biller with status 'A' as @bm_biller" do
      bm_biller = Factory(:bm_biller,:approval_status => 'A')
      get :edit, {:id => bm_biller.id}
      assigns(:bm_biller).should eq(bm_biller)
    end

    it "assigns the new bm_biller with requested bm_biller params when status 'A' as @bm_biller" do
      bm_biller = Factory(:bm_biller,:approval_status => 'A')
      params = (bm_biller.attributes).merge({:approved_id => bm_biller.id,:approved_version => bm_biller.lock_version})
      get :edit, {:id => bm_biller.id}
      assigns(:bm_biller).should eq(BmBiller.new(params))
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new bm_biller" do
        params = Factory.attributes_for(:bm_biller)
        expect {
          post :create, {:bm_biller => params}
        }.to change(BmBiller.unscoped, :count).by(1)
        flash[:alert].should  match(/Biller successfully created and is pending for approval/)
        response.should be_redirect
      end

      it "assigns a newly created bm_biller as @bm_biller" do
        params = Factory.attributes_for(:bm_biller)
        post :create, {:bm_biller => params}
        assigns(:bm_biller).should be_a(BmBiller)
        assigns(:bm_biller).should be_persisted
      end

      it "redirects to the created bm_biller" do
        params = Factory.attributes_for(:bm_biller)
        post :create, {:bm_biller => params}
        response.should redirect_to(BmBiller.unscoped.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bm_biller as @bm_biller" do
        params = Factory.attributes_for(:bm_biller)
        params[:biller_code] = nil
        expect {
          post :create, {:bm_biller => params}
        }.to change(BmBiller, :count).by(0)
        assigns(:bm_biller).should be_a(BmBiller)
        assigns(:bm_biller).should_not be_persisted
      end

      it "re-renders the 'new' template when show_errors is true" do
        params = Factory.attributes_for(:bm_biller)
        params[:biller_code] = nil
        post :create, {:bm_biller => params}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bm_biller" do
        bm_biller = Factory(:bm_biller, :biller_code => "BILL01")
        params = bm_biller.attributes.slice(*bm_biller.class.attribute_names)
        params[:biller_code] = "BILL02"
        put :update, {:id => bm_biller.id, :bm_biller => params}
        bm_biller.reload
        bm_biller.biller_code.should == "BILL02"
      end

      it "assigns the requested bm_biller as @bm_biller" do
        bm_biller = Factory(:bm_biller, :biller_code => "BILL01")
        params = bm_biller.attributes.slice(*bm_biller.class.attribute_names)
        params[:biller_code] = "BILL02"
        put :update, {:id => bm_biller.to_param, :bm_biller => params}
        assigns(:bm_biller).should eq(bm_biller)
      end

      it "redirects to the bm_biller" do
        bm_biller = Factory(:bm_biller, :biller_code => "BILL01")
        params = bm_biller.attributes.slice(*bm_biller.class.attribute_names)
        params[:biller_code] = "BILL02"
        put :update, {:id => bm_biller.to_param, :bm_biller => params}
        response.should redirect_to(bm_biller)
      end

      it "should raise error when tried to update at same time by many" do
        bm_biller = Factory(:bm_biller, :biller_code => "BILL01")
        params = bm_biller.attributes.slice(*bm_biller.class.attribute_names)
        params[:biller_code] = "BILL02"
        bm_biller2 = bm_biller
        put :update, {:id => bm_biller.id, :bm_biller => params}
        bm_biller.reload
        bm_biller.biller_code.should == "BILL02"
        params[:biller_code] = "BILL03"
        put :update, {:id => bm_biller2.id, :bm_biller => params}
        bm_biller.reload
        bm_biller.biller_code.should == "BILL02"
        flash[:alert].should  match(/Someone edited the biller the same time you did. Please re-apply your changes to the biller/)
      end
    end

    describe "with invalid params" do
      it "assigns the bm_biller as @bm_biller" do
        bm_biller = Factory(:bm_biller, :biller_code => "BILL01")
        params = bm_biller.attributes.slice(*bm_biller.class.attribute_names)
        params[:biller_code] = nil
        put :update, {:id => bm_biller.to_param, :bm_biller => params}
        assigns(:bm_biller).should eq(bm_biller)
        bm_biller.reload
        params[:biller_code] = nil
      end

      it "re-renders the 'edit' template when show_errors is true" do
        bm_biller = Factory(:bm_biller)
        params = bm_biller.attributes.slice(*bm_biller.class.attribute_names)
        params[:biller_code] = nil
        put :update, {:id => bm_biller.id, :bm_biller => params, :show_errors => "true"}
        response.should render_template("edit")
      end
    end
  end
 
  describe "GET audit_logs" do
    it "assigns the requested bm_biller as @bm_biller" do
      bm_biller = Factory(:bm_biller)
      get :audit_logs, {:id => bm_biller.id, :version_id => 0}
      assigns(:bm_biller).should eq(bm_biller)
      assigns(:audit).should eq(bm_biller.audits.first)
      get :audit_logs, {:id => 12345, :version_id => "i"}
      assigns(:bm_biller).should eq(nil)
      assigns(:audit).should eq(nil)
    end
  end

  describe "PUT approve" do
    it "(edit) unapproved record can be approved and old approved record will be updated" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      bm_biller1 = Factory(:bm_biller, :approval_status => 'A')
      bm_biller2 = Factory(:bm_biller, :approval_status => 'U', :biller_location => 'Bar Foo', :approved_version => bm_biller1.lock_version, :approved_id => bm_biller1.id, :created_by => 666)
      # the following line is required for reload to get triggered (TODO)
      bm_biller1.approval_status.should == 'A'
      BmUnapprovedRecord.count.should == 1
      put :approve, {:id => bm_biller2.id}
      BmUnapprovedRecord.count.should == 0
      bm_biller1.reload
      bm_biller1.biller_location.should == 'Bar Foo'
      bm_biller1.updated_by.should == "666"
      BmApp.find_by_id(bm_biller2.id).should be_nil
    end

    it "(create) unapproved record can be approved" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      bm_biller = Factory(:bm_biller, :biller_location => 'Bar Foo', :approval_status => 'U')
      BmUnapprovedRecord.count.should == 1
      put :approve, {:id => bm_biller.id}
      BmUnapprovedRecord.count.should == 0
      bm_biller.reload
      bm_biller.biller_location.should == 'Bar Foo'
      bm_biller.approval_status.should == 'A'
    end
  end
end
