class MenuItem < ApplicationRecord
    has_many :order_items
    
    validates :name, presence: true
    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :description, presence: true
  end