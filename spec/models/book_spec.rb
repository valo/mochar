require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Book do
  before(:each) do
    @valid_attributes = {
      :title => "Agile Web Development with Rails",
      :author => "Dave Thomas and David Heinemeier Hansson",
      :price => BigDecimal("23.50")
    }
  end

  it "should create a new instance given valid attributes" do
    Book.create!(@valid_attributes)
  end
end
