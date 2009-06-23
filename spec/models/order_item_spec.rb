require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe OrderItem do
  before(:each) do
    @book_attrs = {
      :title => "Agile Web Development with Rails",
      :author => "Dave Thomas and David Heinemeier Hansson",
      :price => BigDecimal("23.50")
    }

    @user_attrs = {
      :username => 'valo',
      :password => 'secret',
      :email => 'valentin.mihov@example.com'
    }
    
    @order_attrs = {
      :order_type => 'purchase',
      :user => User.new(@user_attrs)
    }
    
    @valid_attributes = {
      :product => Book.new(@book_attrs),
      :order => Order.new(@order_attrs)
    }
  end

  it "should create a new instance given valid attributes" do
    OrderItem.create!(@valid_attributes)
  end
end
