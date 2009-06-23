class Subscription < ActiveRecord::Base
  belongs_to :user
  has_many :order_items, :foreign_key => :product_id, :order => :created_at
  has_many :orders, :through => :order_items, :order => :created_at
  
  validates_presence_of :user, :unless => :refunded?
  validates_presence_of :expires_at
  validates_numericality_of :price
  
  def refundable?
    orders.first.andand.refundable?
  end
  
  def refunded?
    orders.first.andand.refunded?
  end
  
  def refund_amount
    return 0 unless refundable?
    
    order_items.map(&:product).sum(&:price)
  end
  
  def refund!
    return false unless refundable?
    
    Subscription.transaction do
      orders.each(&:refund!)
      
      update_attributes!(:user => nil)
    end
  end
  
  def title
    "Monthly subscription"
  end
  
  def price_in_dollars
    "$#{price}"
  end
  
  def renew!
    Subscription.transaction do
      order = Order.create!(:order_type => 'renewal', :user => user)
      order.order_items.create :product => self
      
      order.save!
      self.expires_at += 1.month
      
      save!
      
      orders.reload
      
      order
    end
  end
end
