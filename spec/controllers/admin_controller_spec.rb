require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdminController do
  before(:each) do
    @admin_user_attrs = {
      :username => 'valo',
      :password => 'secret',
      :email => 'valentin.mihov@gmail.com',
      :is_admin => true
    }
  end
  
  context "login" do
    it "should render the login template" do
      get :login
      
      response.should render_template('login')
    end
    
    it "should redirect to home if the user has admin rights" do
      admin_user = User.new(@admin_user_attrs)
      admin_user.id = 1
      User.stubs(:find_by_username_and_password => admin_user)
      User.expects(:find_by_id).once.with(1).returns(admin_user)
      
      post :do_login
      
      response.should redirect_to(:action => :home)
      controller.send(:get_logged_user).should == admin_user
    end
  end
  
  context "logoff" do
    it "should require a logged user" do
      get :logoff
      
      response.should redirect_to(:action => :login)
    end
    
    it "should logoff the logged user" do
      controller.stubs(:get_logged_user).returns(User.new(@admin_user_attrs))
      controller.expects(:logoff_user).once
      get :logoff
      
      response.should redirect_to(:action => :login)
    end
  end
  
  context "index" do
    it "should redirect to login if there is no user logged in" do
      controller.stubs(:get_logged_user).returns(nil)
      
      get :index
      
      response.should redirect_to(:action => :login)
    end

    it "should redirect to login if there is no admin user logged in" do
      controller.stubs(:get_logged_user).returns(User.new(@admin_user_attrs.merge(:is_admin => false)))
      controller.expects(:logoff_user).once
      
      get :index
      
      response.should redirect_to(:action => :login)
    end

    it "should redirect to home if there is an admin user logged in" do
      controller.stubs(:get_logged_user).returns(User.new(@admin_user_attrs))
      
      get :index
      
      response.should redirect_to(:action => :home)
    end
  end
  
  context "home" do
    it "should redirect to login if there is no user logged in" do
      controller.stubs(:get_logged_user).returns(nil)
      
      get :home
      
      response.should redirect_to(:action => :login)
    end

    it "should redirect to login if there is no admin user logged in" do
      controller.stubs(:get_logged_user).returns(User.new(@admin_user_attrs.merge(:is_admin => false)))
      controller.expects(:logoff_user).once
      
      get :home
      
      response.should redirect_to(:action => :login)
    end
    
    it "should render the home template" do
      controller.stubs(:get_logged_user).returns(User.new(@admin_user_attrs))
      
      get :home
      
      response.should render_template('home')
    end
  end

  context "books" do
    it "should redirect to login if there is no user logged in" do
      controller.stubs(:get_logged_user).returns(nil)
      
      get :books
      
      response.should redirect_to(:action => :login)
    end

    it "should redirect to login if there is no admin user logged in" do
      controller.stubs(:get_logged_user).returns(User.new(@admin_user_attrs.merge(:is_admin => false)))
      controller.expects(:logoff_user).once
      
      get :books
      
      response.should redirect_to(:action => :login)
    end
    
    it "should render the books template" do
      controller.stubs(:get_logged_user).returns(User.new(@admin_user_attrs))
      
      get :books
      
      response.should render_template('books')
    end
  end
end
