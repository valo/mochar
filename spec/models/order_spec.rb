require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Order do
  before(:each) do
    @user_attrs = {
      :username => 'valo',
      :password => 'secret',
      :email => 'valentin.mihov@example.com'
    }
    @user = User.new(@user_attrs)
    
    @order_attrs = {
      :order_type => 'purchase',
      :user => @user
    }
    
    @book_attrs = {
      :title => "Agile Web Development with Rails",
      :author => "Dave Thomas and David Heinemeier Hansson",
      :price => BigDecimal("23.50")
    }
    
    @subscription_attrs = {
      :user => @user,
      :price => BigDecimal("9.95"),
      :expires_at => 1.month.from_now
    }
  end

  it "should create a new instance given valid attributes" do
    Order.create!(@order_attrs)
  end
  
  it "should not allow refunds of orders with books" do
    book = Book.create!(@book_attrs)
    order = Order.create!(@order_attrs)
    
    order.order_items.create :product => book
    
    order.should_not be_refundable
  end
  
  it "should allow refunds of orders with a subscription" do
    subscription = Subscription.create!(@subscription_attrs)
    order = Order.create!(@order_attrs)
    
    order.order_items.create :product => subscription
    
    order.should be_refundable
  end
  
  it "should not be refundable 30 days after the purchase" do
    subscription = Subscription.create!(@subscription_attrs)
    order = Order.create!(@order_attrs)
    
    order.order_items.create :product => subscription
    
    Time.stubs(:now => 30.days.from_now)
    
    order.should_not be_refundable
  end
  
  it "should be refundable after 1 month after purchased on 1 february" do
    Time.stubs(:now => Time.parse('1 Feb 2005'))
    
    subscription = Subscription.create!(@subscription_attrs.merge(:expires_at => 1.month.from_now))
    order = Order.create!(@order_attrs)
    
    order.order_items.create :product => subscription
    
    Time.stubs(:now => 1.month.from_now)
    
    order.should be_refundable
  end
end
