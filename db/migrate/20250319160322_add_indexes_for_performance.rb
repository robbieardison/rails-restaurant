class AddIndexesForPerformance < ActiveRecord::Migration[6.1]
  def change
    # Add indexes to frequently queried columns
    add_index :orders, :created_at
    add_index :orders, [:customer_id, :created_at]
    add_index :orders, [:status, :created_at]
    
    add_index :reservations, [:customer_id, :reserved_at]
    add_index :reservations, [:status, :reserved_at]
    
    add_index :menu_items, :available
    
    add_index :order_items, [:order_id, :menu_item_id]
  end
end