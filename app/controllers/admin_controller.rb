class AdminController < ApplicationController
  before_filter :require_logged_admin_user, 
                :except => [:login, :do_login]
  
  def index
    redirect_to :action => :home
  end
  
  def login
    @user = User.new
  end
  
  def do_login
    params[:user] ||= {}
    @user = User.find_by_username_and_password(
                  params[:user][:username], 
                  User.encrypt_pass(params[:user][:password]))
    if @user
      session[:logged_user_id] = @user.id
      redirect_to :action => :home
    else
      flash[:error] = "Invalid username or password"
      render :action => :login
    end
  end
  
  def logoff
    logoff_user
    redirect_to :action => :login
  end
  
  def add_book
    @book = Book.new
  end
  
  def do_add_book
    @book = Book.new(params[:book])
    
    if @book.save
      redirect_to :action => :books
    else
      render :action => :add_book
    end
  end
  
  def delete_book
    @book = Book.find(params[:id])
    @book.destroy
    
    redirect_to :action => "books"
  end
  
  def edit_book
    @book = Book.find(params[:id])
  end
  
  def do_edit_book
    @book = Book.find(params[:id])
    @book.attributes = params[:book]
    if @book.save
      redirect_to :action => :books
    else
      render :action => :edit_book
    end
  end
  
  def home
  end
  
  def books
    @books = Book.all
  end
  
  def users
    @users = User.all
  end
  
  def add_user
    @user = User.new
  end
  
  def do_add_user
    @user = User.new(params[:user])
    if @user.save
      redirect_to :action => :users
    else
      @user.password = @user.password_confirmation = nil
      render :action => :add_user
    end
  end
  
  def edit_user
    @user = User.find(params[:id])
    @user.password = nil
  end
  
  def do_edit_user
    @user = User.find(params[:id])
    params[:user].except!(:password, :password_confirmation) if params[:user][:password].blank?
    @user.attributes = params[:user]
    
    if @user.save
      redirect_to :action => :users
    else
      @user.password = @user.password_confirmation = nil
      render :action => :edit_user
    end
  end
  
  def delete_user
    @user = User.find(params[:id])
    @user.destroy
    redirect_to :action => :users
  end
  
  protected
    
    def require_logged_admin_user
      if !get_logged_user or !get_logged_user.is_admin?
        logoff_user
        redirect_to :action => :login
      end
    end
end
