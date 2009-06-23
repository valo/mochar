require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Subscription do
  before(:each) do
    @user_attrs = {
      :username => 'valo',
      :password => 'secret',
      :email => 'valentin.mihov@example.com'
    }
    @user = User.create!(@user_attrs)
    
    @order_attrs = {
      :order_type => 'purchase',
      :user => @user
    }
    
    @valid_attributes = {
      :user => @user,
      :price => BigDecimal("9.95"),
      :expires_at => 1.month.from_now
    }
  end

  it "should create a new instance given valid attributes" do
    Subscription.create!(@valid_attributes)
  end
  
  context "renew!" do
    it "should extend the subscription with 1 month" do
      subs = Subscription.create!(@valid_attributes)
      subs.renew!
      
      subs.expires_at.should be_close(2.months.from_now, 1.minute)
    end
    
    it "should create a new order" do
      lambda do
        subs = Subscription.create!(@valid_attributes)
        subs.renew!
      end.should change { Order.count }.by(1)
    end
  end
  
  context "refund!" do
    it "should refund the order after 29 days" do
      subs = Subscription.create!(@valid_attributes)
      order = Order.create!(@order_attrs)
      order.order_items.create :product => subs
      
      Time.stubs(:now => 29.days.from_now)
      
      subs.should be_refundable
    end
    
    it "should refund the order" do
      subs = Subscription.create!(@valid_attributes)
      order = Order.create!(@order_attrs)
      order.order_items.create :product => subs
      
      Time.stubs(:now => 29.days.from_now)
      
      subs.refund!
      
      subs.orders.each do |order|
        order.should be_refunded
      end
    end
    
    it "should refund all the orders if there are several" do
      # Set the current time to february 1st 2005. This month has 28 days
      Time.stubs(:now => Time.parse("1 Feb 2005"))

      # Create a subscription
      subs = Subscription.create!(@valid_attributes)
      order = Order.create!(@order_attrs)
      order.order_items.create :product => subs
      
      # Set the current time to 1 March
      Time.stubs(:now => 1.month.from_now)
      
      # Renew the subscription
      subs.renew!
      
      # Refund the subscription
      subs.refund!
      
      # It should refund all the orders assigned to the subscription
      subs.should be_refundable
      subs.should have(2).orders
      subs.orders.each do |order|
        order.should be_refunded
      end
    end
  end
end
