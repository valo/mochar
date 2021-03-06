require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BookController do
  integrate_views
  
  before(:each) do
    @book_attributes = {
      :title => "Agile Web Development with Rails",
      :author => "Dave Thomas and David Heinemeier Hansson",
      :price => BigDecimal("23.50")
    }

    @user_attributes = {
      :username => 'valo',
      :password => 'secret',
      :email => 'valentin.mihov@example.org'
    }
  end

  it "should use BookController" do
    controller.should be_an_instance_of(BookController)
  end
  
  context "index" do
    it "should render the index template" do
      get :index
      
      response.should render_template('index')
    end
    
    it "should show no books if there are no books in the system" do
      Book.stubs(:all => [])
      
      get :index
      
      response.should include_text("No books available")
    end
    
    it "should list each book title if there are books in the system" do
      Book.stubs(:all => [
        Book.new(@book_attributes),
        Book.new(@book_attributes.merge(:title => "Deploying Rails Applications")),
        Book.new(@book_attributes.merge(:title => "Pragmatic Thinking and Learning"))
        ])
        
      
      get :index
      Book.all.each do |book|
        response.should include_text(book.title)
      end
    end
  end
  
  context "do_order_subscription" do
    it "should show proper error message if the payment is rejected" do
      CreditCardProcessor.stubs(:charge_for_order).raises(PaymentError)
      user = User.new(@user_attributes)
      controller.stubs(:get_logged_user).returns(user)
      
      lambda {
        post :do_order_subscription
        
        flash[:error].should_not be_blank
        response.should render_template('order_subscription')
      }.should_not change { Order.count }
    end

    it "should show create new order if the transaction is successful" do
      user = User.new(@user_attributes)
      controller.stubs(:get_logged_user).returns(user)
      
      lambda {
        post :do_order_subscription
      }.should change { Order.count }.by(1)
    end
  end
end
