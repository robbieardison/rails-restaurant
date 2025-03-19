class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.references :customer, null: false, foreign_key: true
      t.integer :table_number, null: false
      t.datetime :reserved_at, null: false
      t.integer :status, default: 0, null: false
      
      t.timestamps
    end
    
    add_index :reservations, [:table_number, :reserved_at]
  end
end