class OrderItem < ApplicationRecord
    belongs_to :order
    belongs_to :menu_item
    
    validates :quantity, presence: true, numericality: { greater_than: 0 }
    validates :unit_price, presence: true, numericality: { greater_than: 0 }
    
    def subtotal
      quantity * unit_price
    end
end