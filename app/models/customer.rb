class Customer < ApplicationRecord
    has_many :orders
    has_many :reservations
    
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
  
    scope :frequent_customers, -> {
      joins(:orders)
        .where('orders.created_at >= ?', 30.days.ago)
        .group('customers.id')
        .having('COUNT(orders.id) >= 5')
        .includes(:orders) # Avoids N+1 queries when loading order details
    }
    before_create :generate_api_key
  
    private
    
    def generate_api_key
      self.api_key = SecureRandom.hex(24)
    end
  end