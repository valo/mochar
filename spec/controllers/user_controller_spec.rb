require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserController do
  integrate_views
  
  before(:each) do
    @user_attributes = {
      :username => 'valo',
      :password => 'secret',
      :email => 'valentin.mihov@example.org'
    }
  end

  #Delete this example and add some real ones
  it "should use UserController" do
    controller.should be_an_instance_of(UserController)
  end

  context "login" do
    it "should render the login template when the user is not logged in" do
      get :login
      
      response.should render_template('login')
    end
    
    it "should redirect to home when the user is logged in" do
      
      get :login
      
      response.should render_template('login')
    end
    
    it "should render login if the credentials are invalid" do
      post :do_login
      
      response.should render_template('login')
      flash[:error].should_not be_blank
    end
    
    it "should render the home page if the credentials are valid" do
      User.stubs(:find_by_username_and_password).returns(User.new(@user_attributes))
      
      post :do_login
      
      response.should redirect_to(:controller => :book, :action => :index)
    end
  end
  
  context "index" do
    it "should redirect to the home if the user is logged in" do
      user = User.new(@user_attributes)
      controller.stubs(:get_logged_user).returns(user)
      
      get :index
      
      response.should redirect_to(:action => :home)
    end

    it "should redirect to login if the user is not logged in" do
      controller.stubs(:get_logged_user).returns(nil)
      
      get :index
      
      response.should redirect_to(:action => :login)
    end
  end

  context "register" do
    it "should render the register page if the user info is invalid" do
      post :do_register
      
      response.should render_template(:register)
    end
    
    it "should create a new user if the info is valid" do
      lambda do
        post :do_register, :user => @user_attributes
        
        response.should redirect_to(:action => :home)
      end.should change { User.count }.by(1)
    end
    
    it "should send email to the new registered users" do
      Notifications.expects(:deliver_user_registered).once.with do |user|
        user.username == @user_attributes[:username]
      end
      
      post :do_register, :user => @user_attributes
    end
    
    it "should not send emails if the user data is invalid" do
      Notifications.expects(:deliver_user_registered).never
      
      post :do_register
    end
  end
  
  context "logoff" do
    it "should redirect to the login page" do
      get :logoff
      
      response.should redirect_to(:action => :login)
    end
    
    it "should logoff the currenty logged user" do
      controller.expects(:logoff_user).once
      
      get :logoff
    end
  end
end
