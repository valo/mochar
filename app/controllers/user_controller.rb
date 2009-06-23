class UserController < ApplicationController
  layout 'application'
  
  def login
    if get_logged_user
      redirect_to :controller => :book, :action => :index
      return
    end
    
    @user = User.new
  end
  
  def do_login
    params[:user] ||= {}
    @user = User.find_by_username_and_password(
                  params[:user][:username], 
                  User.encrypt_pass(params[:user][:password]))
    if @user
      session[:logged_user_id] = @user.id
      redirect_to :controller => :book, :action => :index
    else
      flash[:error] = "Invalid username or password"
      render :action => :login
    end
  end
  
  def index
    if get_logged_user
      redirect_to :action => :home
    else
      redirect_to :action => :login
    end
  end
  
  def register
    @user = User.new
  end
  
  def do_register
    @user = User.new(params[:user])
    
    if @user.save
      Notifications.deliver_user_registered(@user)
      redirect_to :action => :home
    else
      @user.password = @user.password_confirmation = nil
      render :action => :register
    end
  end
  
  def logoff
    logoff_user
    if request.env["HTTP_REFERER"]
      redirect_to :back
    else
      redirect_to :action => :login
    end
  end
  
  def home
    
  end
end
