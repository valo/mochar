class OrderItem < ActiveRecord::Base
  belongs_to :product, :polymorphic => true
  belongs_to :order
  
  validates_presence_of :order, :product
end
