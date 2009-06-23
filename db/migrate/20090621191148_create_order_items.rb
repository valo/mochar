class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.references :order, :null => false
      t.references :product, :polymorphic => { :default => 'Book' }, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :order_items
  end
end
