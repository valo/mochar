class Order < ActiveRecord::Base
  has_many :order_items
  belongs_to :user
  
  validates_presence_of :user
  validates_inclusion_of :order_type, :in => %w( purchase renewal )
  
  def purchase?
    type == 'purchase'
  end
  
  def renewal?
    type == 'renewal'
  end
  
  def total_price
    order_items.map(&:product).map(&:price).sum
  end
  
  def refundable?
    order_items.size == 1 and order_items.first.product.kind_of?(Subscription) and
    !refunded? and Time.now < refundable_before
  end
  
  def refundable_before
    created_at + 30.days
  end
  
  def refund!
    raise ArgumentError, "Cannot refund an order which is not refundable!" unless refundable?
    
    update_attributes!(:refunded => true)
  end
end
