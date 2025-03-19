class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.decimal :total_amount, precision: 10, scale: 2, default: 0
      t.text :notes
      
      t.timestamps
    end
  end
end