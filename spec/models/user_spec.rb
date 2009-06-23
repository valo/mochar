require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  before(:each) do
    @valid_attributes = {
      :username => 'valo',
      :password => 'secret',
      :email => 'valentin.mihov@example.com'
    }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@valid_attributes)
  end
  
  it "should create non-admin users by default" do
    user = User.create!(@valid_attributes)
    
    user.should_not be_is_admin
  end
  
  it "should encrypt the password" do
    user = User.create!(@valid_attributes)
    
    user.password.should_not == @valid_attributes[:password]
  end
  
  it "should not allow having two users with the same username" do
    lambda do
      User.create!(@valid_attributes)
      user = User.create(@valid_attributes)
    
      user.should have(2).errors
    end.should change { User.count }.by(1)
  end
end
