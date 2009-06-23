require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of :username, :email, :password
  validates_uniqueness_of :username
  validates_uniqueness_of :email
  validates_confirmation_of :password
  
  has_one :subscription
  has_many :orders
  
  def password=(pass)
    write_attribute(:password, self.class.encrypt_pass(pass))
  end

  def password_confirmation=(pass)
    @password_confirmation = self.class.encrypt_pass(pass)
  end
  
  def display_name
    return real_name unless real_name.blank?
    username
  end
  
  def self.encrypt_pass(pass)
    return nil unless pass
    Digest::SHA1.hexdigest("mochar-rulz! #{pass}")
  end
end
