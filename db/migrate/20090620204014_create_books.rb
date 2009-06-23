class CreateBooks < ActiveRecord::Migration
  def self.up
    create_table :books do |t|
      t.string :title, :null => false
      t.decimal :price, :precision => 10, :scale => 2, :null => false
      t.string :author, :null => false
      t.text :description
      t.timestamps
    end
  end

  def self.down
    drop_table :books
  end
end
