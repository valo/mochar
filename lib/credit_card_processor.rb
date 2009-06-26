class PaymentError < StandardError
end

class CreditCardProcessor
  class << self
    def charge_for_order(order, billing_info)
      order.purchase_id = (1..8).to_a.map { (0..9).to_a.rand.to_s }.join
    end
    
    def refund_order(order)
      raise "Cannot refund an order without a purchase id!" if order.purchase_id.blank?
    end
  end
end
