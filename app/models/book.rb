class Book < ActiveRecord::Base
  validates_presence_of :title, :author, :price
  validates_numericality_of :price
  
  def price_in_dollars
    "$#{price}"
  end
end
