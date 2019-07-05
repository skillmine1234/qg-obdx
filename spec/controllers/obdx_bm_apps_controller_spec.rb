require 'spec_helper'

describe ObdxBmAppsController do
  
  include HelperMethods
  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
  end

  describe "GET index" do
    it "assigns all bm_apps as @bm_apps" do
      bm_app = Factory(:bm_app, :approval_status => 'A')
      get :index
      assigns(:bm_apps).should eq([bm_app])
    end

    it "assigns all unapproved bm_apps as @bm_apps when approval_status is passed" do
      bm_app = Factory(:bm_app, :approval_status => 'U')
      get :index, :approval_status => 'U'
      assigns(:bm_apps).should eq([bm_app])
    end
  end

  describe "GET show" do
    it "assigns the requested bm_app as @bm_app" do
      bm_app = Factory(:bm_app)
      get :show, {:id => bm_app.id}
      assigns(:bm_app).should eq(bm_app)
    end
  end

  describe "GET new" do
    it "assigns a new bm_app as @bm_app" do
      get :new
      assigns(:bm_app).should be_a_new(BmApp)
    end
  end

  describe "GET edit" do
    it "assigns the requested bm_app with status 'U' as @bm_app" do
      bm_app = Factory(:bm_app, :approval_status => 'U')
      get :edit, {:id => bm_app.id}
      assigns(:bm_app).should eq(bm_app)
    end

    it "assigns the requested bm_app with status 'A' as @bm_app" do
      bm_app = Factory(:bm_app,:approval_status => 'A')
      get :edit, {:id => bm_app.id}
      assigns(:bm_app).should eq(bm_app)
    end

    it "assigns the new bm_app with requested bm_app params when status 'A' as @bm_app" do
      bm_app = Factory(:bm_app,:approval_status => 'A')
      params = (bm_app.attributes).merge({:approved_id => bm_app.id,:approved_version => bm_app.lock_version})
      get :edit, {:id => bm_app.id}
      assigns(:bm_app).should eq(BmApp.new(params))
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new bm_app" do
        params = Factory.attributes_for(:bm_app)
        expect {
          post :create, {:bm_app => params}
        }.to change(BmApp.unscoped, :count).by(1)
        flash[:alert].should  match(/Bm App successfully created and is pending for approval/)
        response.should be_redirect
      end

      it "assigns a newly created bm_app as @bm_app" do
        params = Factory.attributes_for(:bm_app)
        post :create, {:bm_app => params}
        assigns(:bm_app).should be_a(BmApp)
        assigns(:bm_app).should be_persisted
      end

      it "redirects to the created bm_app" do
        params = Factory.attributes_for(:bm_app)
        post :create, {:bm_app => params}
        response.should redirect_to(BmApp.unscoped.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bm_app as @bm_app" do
        params = Factory.attributes_for(:bm_app)
        params[:app_id] = nil
        expect {
          post :create, {:bm_app => params}
        }.to change(BmApp, :count).by(0)
        assigns(:bm_app).should be_a(BmApp)
        assigns(:bm_app).should_not be_persisted
      end

      it "re-renders the 'new' template when show_errors is true" do
        params = Factory.attributes_for(:bm_app)
        params[:app_id] = nil
        post :create, {:bm_app => params}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bm_app" do
        bm_app = Factory(:bm_app)
        params = bm_app.attributes.slice(*bm_app.class.attribute_names)
        params[:app_id] = "BILL02"
        put :update, {:id => bm_app.id, :bm_app => params}
        bm_app.reload
        bm_app.app_id.should == "BILL02"
      end

      it "assigns the requested bm_app as @bm_app" do
        bm_app = Factory(:bm_app)
        params = bm_app.attributes.slice(*bm_app.class.attribute_names)
        params[:app_id] = "BILL02"
        put :update, {:id => bm_app.to_param, :bm_app => params}
        assigns(:bm_app).should eq(bm_app)
      end

      it "redirects to the bm_app" do
        bm_app = Factory(:bm_app)
        params = bm_app.attributes.slice(*bm_app.class.attribute_names)
        params[:app_id] = "BILL02"
        put :update, {:id => bm_app.to_param, :bm_app => params}
        response.should redirect_to(bm_app)
      end

      it "should raise error when tried to update at same time by many" do
        bm_app = Factory(:bm_app)
        params = bm_app.attributes.slice(*bm_app.class.attribute_names)
        params[:app_id] = "BILL02"
        bm_app2 = bm_app
        put :update, {:id => bm_app.id, :bm_app => params}
        bm_app.reload
        bm_app.app_id.should == "BILL02"
        params[:app_id] = "BILL03"
        put :update, {:id => bm_app2.id, :bm_app => params}
        bm_app.reload
        bm_app.app_id.should == "BILL02"
        flash[:alert].should  match(/Someone edited the bm_app the same time you did. Please re-apply your changes to the bm_app/)
      end
    end

    describe "with invalid params" do
      it "assigns the bm_app as @bm_app" do
        bm_app = Factory(:bm_app)
        params = bm_app.attributes.slice(*bm_app.class.attribute_names)
        params[:app_id] = nil
        put :update, {:id => bm_app.to_param, :bm_app => params}
        assigns(:bm_app).should eq(bm_app)
        bm_app.reload
        params[:biller_code] = nil
      end

      it "re-renders the 'edit' template when show_errors is true" do
        bm_app = Factory(:bm_app)
        params = bm_app.attributes.slice(*bm_app.class.attribute_names)
        params[:app_id] = nil
        put :update, {:id => bm_app.id, :bm_app => params, :show_errors => "true"}
        response.should render_template("edit")
      end
    end
  end
 
  describe "GET audit_logs" do
    it "assigns the requested bm_app as @bm_app" do
      bm_app = Factory(:bm_app)
      get :audit_logs, {:id => bm_app.id, :version_id => 0}
      assigns(:bm_app).should eq(bm_app)
      assigns(:audit).should eq(bm_app.audits.first)
      get :audit_logs, {:id => 12345, :version_id => "i"}
      assigns(:bm_app).should eq(nil)
      assigns(:audit).should eq(nil)
    end
  end

  describe "PUT approve" do
    it "(edit) unapproved record can be approved and old approved record will be updated" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      bm_app1 = Factory(:bm_app, :approval_status => 'A')
      bm_app2 = Factory(:bm_app, :approval_status => 'U', :channel_id => 'Bar Foo', :approved_version => bm_app1.lock_version, :approved_id => bm_app1.id, :created_by => 666)
      # the following line is required for reload to get triggered (TODO)
      bm_app1.approval_status.should == 'A'
      BmUnapprovedRecord.count.should == 1
      put :approve, {:id => bm_app2.id}
      BmUnapprovedRecord.count.should == 0
      bm_app1.reload
      bm_app1.channel_id.should == 'Bar Foo'
      bm_app1.updated_by.should == "666"
      BmBiller.find_by_id(bm_app2.id).should be_nil
    end

    it "(create) unapproved record can be approved" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      bm_app = Factory(:bm_app, :channel_id => 'Bar Foo', :approval_status => 'U')
      BmUnapprovedRecord.count.should == 1
      put :approve, {:id => bm_app.id}
      BmUnapprovedRecord.count.should == 0
      bm_app.reload
      bm_app.channel_id.should == 'Bar Foo'
      bm_app.approval_status.should == 'A'
    end
  end

end
