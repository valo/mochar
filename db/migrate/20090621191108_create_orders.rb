class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :user, :null => false
      t.string :order_type, :null => false, :default => 'purchase'
      t.boolean :refunded, :null => false, :default => false
      t.string :purchase_id
      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
