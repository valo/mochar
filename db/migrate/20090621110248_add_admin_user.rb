class AddAdminUser < ActiveRecord::Migration
  def self.up
    User.create!(:username => 'valo',
                 :password => '123123',
                 :email => 'valentin.mihov@gmail.com',
                 :real_name => 'Valentin Mihov')
  end

  def self.down
    User.destroy_all(:username => 'valo')
  end
end
