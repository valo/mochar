class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :subscriptions do |t|
      t.references :user
      t.datetime :expires_at, :null => false
      t.integer :times_renewed, :default => 0, :null => false
      t.decimal :price, :precision => 10, :scale => 2, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :subscriptions
  end
end
