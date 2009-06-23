class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :null => false
      t.string :email, :null => false
      t.string :password, :null => false
      t.string :real_name
      t.boolean :is_admin, :null => false, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
