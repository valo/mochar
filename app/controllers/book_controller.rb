require 'ostruct'

class BookController < ApplicationController
  before_filter :init_cart
  before_filter :require_logged_user, :only => [:purchase_subscription, 
                                                :order_subscription, 
                                                :do_order_subscription,
                                                :refund_subscription]
  
  def index
    @books = Book.all
  end
  
  def add_to_cart
    product = Book.find(params[:id])
    session[:cart] << product.id
    
    redirect_to :back
  end
  
  def cart
    @cart = session[:cart].uniq.map { |item_id| [Book.find(item_id), session[:cart].grep(item_id).size] }
  end
  
  def empty_cart
    session[:cart] = []
    redirect_to :action => "cart"
  end
  
  def purchase_subscription
  end
  
  def order_subscription
    @billing_info = OpenStruct.new(:credit_card_holder_name => get_logged_user.real_name)
  end
  
  def do_order_subscription
    @billing_info = OpenStruct.new(params[:billing_info])
    
    Subscription.transaction do
      subs = Subscription.create!(:user => get_logged_user, :price => BigDecimal("9.95"), :expires_at => 1.month.from_now)
      order = Order.create!(:order_type => 'purchase', :user => get_logged_user)
      order.order_items.create! :product => subs
      
      CreditCardProcessor.charge_for_order(order, @billing_info)
    end
    flash[:notice] = "Subscription successfuly purchased!"
    redirect_to :action => :index
  rescue
    logger.info $!.inspect
    flash[:error] = "Cannot make a purchase. Please review your billing info."
    render :action => :order_subscription
  end
  
  def refund_subscription
    redirect_to :action => "index" unless get_logged_user.subscription and get_logged_user.subscription.refundable?
    
    if !get_logged_user.subscription.refund!
      get_logged_user.reload
      flash[:error] = "Cannot refund the subscription"
    else
      flash[:notice] = "Subscription successfully refunded"
    end
    
    redirect_to :action => :my_account
  end
  
  def my_account
    @user = get_logged_user
    
    redirect_to :controller => :user, :action => "login" unless @user
  end
  
  def checkout
    @cart = session[:cart].uniq.map { |item_id| [Book.find(item_id), session[:cart].grep(item_id).size] }
    @billing_info = OpenStruct.new(:credit_card_holder_name => get_logged_user.real_name)
  end
  
  def do_checkout
    @billing_info = OpenStruct.new(params[:billing_info])

    Order.transaction do
      order = Order.create!(:order_type => 'purchase', :user => get_logged_user)
      session[:cart].each do |item_id|
        order.order_items.create! :product => Book.find(item_id)
      end

      CreditCardProcessor.charge_for_order(order, @billing_info)
    end
    session[:cart] = []
    flash[:notice] = "Checkout was successful!"
    redirect_to :action => :index
  rescue
    logger.info $!.inspect
    flash[:error] = "Cannot make a purchase. Please review your billing info."
    render :action => :checkout
  end
  
  protected
    def init_cart
      session[:cart] ||= []
    end
end
