require 'spec_helper'

describe ObdxBmAggregatorPaymentsController do
  include HelperMethods
  
  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'editor').id)
    request.env["HTTP_REFERER"] = "/"
  end

  describe "GET index" do
    it "assigns all bm_aggregator_payments as @bm_aggregator_payments" do
      bm_aggregator_payment = Factory(:bm_aggregator_payment, :approval_status => 'A')
      get :index
      assigns(:bm_aggregator_payments).should eq([bm_aggregator_payment])
    end

    it "assigns all unapproved bm_aggregator_payments as @bm_aggregator_payments when approval_status is passed" do
      bm_aggregator_payment = Factory(:bm_aggregator_payment, :approval_status => 'U')
      get :index, :approval_status => 'U'
      assigns(:bm_aggregator_payments).should eq([bm_aggregator_payment])
    end
  end

  describe "GET show" do
    it "assigns the requested bm_aggregator_payment as @bm_aggregator_payment" do
      bm_aggregator_payment = Factory(:bm_aggregator_payment)
      get :show, {:id => bm_aggregator_payment.id}
      assigns(:bm_aggregator_payment).should eq(bm_aggregator_payment)
    end
  end

  describe "GET new" do
    it "assigns a new bm_aggregator_payment as @bm_aggregator_payment" do
      get :new
      assigns(:bm_aggregator_payment).should be_a_new(BmAggregatorPayment)
    end
  end

  describe "GET edit" do
    it "assigns the requested bm_aggregator_payment with status 'U' as @bm_aggregator_payment" do
      bm_aggregator_payment = Factory(:bm_aggregator_payment, :approval_status => 'U')
      get :edit, {:id => bm_aggregator_payment.id}
      assigns(:bm_aggregator_payment).should eq(bm_aggregator_payment)
    end

    it "does not allow the user to edit a bm_aggregator_payment approved record" do
      bm_aggregator_payment = Factory(:bm_aggregator_payment,:approval_status => 'A')
      params = (bm_aggregator_payment.attributes).merge({:approved_id => bm_aggregator_payment.id,:approved_version => bm_aggregator_payment.lock_version})
      get :edit, {:id => bm_aggregator_payment.id}
      response.should be_redirect
      # assigns(:bm_aggregator_payment).should eq(BmAggregatorPayment.new(params))
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new bm_aggregator_payment" do
        params = Factory.attributes_for(:bm_aggregator_payment)
        expect {
          post :create, {:bm_aggregator_payment => params}
        }.to change(BmAggregatorPayment.unscoped, :count).by(1)
        flash[:alert].should  match(/Aggregator Payment successfully created and is pending for approval/)
        response.should be_redirect
      end

      it "assigns a newly created bm_aggregator_payment as @bm_aggregator_payment" do
        params = Factory.attributes_for(:bm_aggregator_payment)
        post :create, {:bm_aggregator_payment => params}
        assigns(:bm_aggregator_payment).should be_a(BmAggregatorPayment)
        assigns(:bm_aggregator_payment).should be_persisted
      end

      it "redirects to the created bm_aggregator_payment" do
        params = Factory.attributes_for(:bm_aggregator_payment)
        post :create, {:bm_aggregator_payment => params}
        response.should redirect_to(BmAggregatorPayment.unscoped.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved bm_aggregator_payment as @bm_aggregator_payment" do
        params = Factory.attributes_for(:bm_aggregator_payment)
        params[:bene_name] = nil
        expect {
          post :create, {:bm_aggregator_payment => params}
        }.to change(BmAggregatorPayment, :count).by(0)
        assigns(:bm_aggregator_payment).should be_a(BmAggregatorPayment)
        assigns(:bm_aggregator_payment).should_not be_persisted
      end

      it "re-renders the 'new' template when show_errors is true" do
        params = Factory.attributes_for(:bm_aggregator_payment)
        params[:bene_name] = nil
        post :create, {:bm_aggregator_payment => params}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested bm_aggregator_payment" do
        bm_aggregator_payment = Factory(:bm_aggregator_payment, :bene_name => "BILL01")
        params = bm_aggregator_payment.attributes.slice(*bm_aggregator_payment.class.attribute_names)
        params[:bene_name] = "BILL02"
        put :update, {:id => bm_aggregator_payment.id, :bm_aggregator_payment => params}
        bm_aggregator_payment.reload
        bm_aggregator_payment.bene_name.should == "BILL02"
      end

      it "assigns the requested bm_aggregator_payment as @bm_aggregator_payment" do
        bm_aggregator_payment = Factory(:bm_aggregator_payment, :bene_name => "BILL01")
        params = bm_aggregator_payment.attributes.slice(*bm_aggregator_payment.class.attribute_names)
        params[:bene_name] = "BILL02"
        put :update, {:id => bm_aggregator_payment.to_param, :bm_aggregator_payment => params}
        assigns(:bm_aggregator_payment).should eq(bm_aggregator_payment)
      end

      it "redirects to the bm_aggregator_payment" do
        bm_aggregator_payment = Factory(:bm_aggregator_payment, :bene_name => "BILL01")
        params = bm_aggregator_payment.attributes.slice(*bm_aggregator_payment.class.attribute_names)
        params[:bene_name] = "BILL02"
        put :update, {:id => bm_aggregator_payment.to_param, :bm_aggregator_payment => params}
        response.should redirect_to(bm_aggregator_payment)
      end

      it "should raise error when tried to update at same time by many" do
        bm_aggregator_payment = Factory(:bm_aggregator_payment, :bene_name => "BILL01")
        params = bm_aggregator_payment.attributes.slice(*bm_aggregator_payment.class.attribute_names)
        params[:bene_name] = "BILL02"
        bm_aggregator_payment2 = bm_aggregator_payment
        put :update, {:id => bm_aggregator_payment.id, :bm_aggregator_payment => params}
        bm_aggregator_payment.reload
        bm_aggregator_payment.bene_name.should == "BILL02"
        params[:bene_name] = "BILL03"
        put :update, {:id => bm_aggregator_payment2.id, :bm_aggregator_payment => params}
        bm_aggregator_payment.reload
        bm_aggregator_payment.bene_name.should == "BILL02"
        flash[:alert].should  match(/Someone edited the aggregator payment the same time you did. Please re-apply your changes to the aggregator payment./)
      end
    end

    describe "with invalid params" do
      it "assigns the bm_aggregator_payment as @bm_aggregator_payment" do
        bm_aggregator_payment = Factory(:bm_aggregator_payment, :bene_name => "BILL01")
        params = bm_aggregator_payment.attributes.slice(*bm_aggregator_payment.class.attribute_names)
        params[:bene_name] = nil
        put :update, {:id => bm_aggregator_payment.to_param, :bm_aggregator_payment => params}
        assigns(:bm_aggregator_payment).should eq(bm_aggregator_payment)
        bm_aggregator_payment.reload
        params[:bene_name] = nil
      end

      it "re-renders the 'edit' template when show_errors is true" do
        bm_aggregator_payment = Factory(:bm_aggregator_payment)
        params = bm_aggregator_payment.attributes.slice(*bm_aggregator_payment.class.attribute_names)
        params[:bene_name] = nil
        put :update, {:id => bm_aggregator_payment.id, :bm_aggregator_payment => params, :show_errors => "true"}
        response.should render_template("edit")
      end
    end
  end
 
  describe "GET audit_logs" do
    it "assigns the requested bm_aggregator_payment as @bm_aggregator_payment" do
      bm_aggregator_payment = Factory(:bm_aggregator_payment)
      get :audit_logs, {:id => bm_aggregator_payment.id, :version_id => 0}
      assigns(:bm_aggregator_payment).should eq(bm_aggregator_payment)
      assigns(:audit).should eq(bm_aggregator_payment.audits.first)
      get :audit_logs, {:id => 12345, :version_id => "i"}
      assigns(:bm_aggregator_payment).should eq(nil)
      assigns(:audit).should eq(nil)
    end
  end

  describe "PUT approve" do
    it "(edit) approved record will redirect" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      bm_aggregator_payment1 = Factory(:bm_aggregator_payment, :approval_status => 'A')
      bm_aggregator_payment2 = Factory.build(:bm_aggregator_payment, :approval_status => 'U', :bene_name => 'Bar Foo', :approved_version => bm_aggregator_payment1.lock_version, :approved_id => bm_aggregator_payment1.id)
      bm_aggregator_payment2.save.should == false
    end

    it "(create) unapproved record can be approved" do
      user_role = UserRole.find_by_user_id(@user.id)
      user_role.delete
      Factory(:user_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'supervisor').id)
      bm_aggregator_payment = Factory(:bm_aggregator_payment, :bene_name => 'Bar Foo', :approval_status => 'U')
      BmUnapprovedRecord.count.should == 1
      put :approve, {:id => bm_aggregator_payment.id}
      BmUnapprovedRecord.count.should == 0
      bm_aggregator_payment.reload
      bm_aggregator_payment.bene_name.should == 'Bar Foo'
      bm_aggregator_payment.approval_status.should == 'A'
    end
  end

end
