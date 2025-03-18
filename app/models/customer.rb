class Customer < ApplicationRecord
    has_many :orders
  
    scope :frequent_customers, -> {
      joins(:orders)
        .where('orders.created_at >= ?', 30.days.ago)
        .group('customers.id')
        .having('COUNT(orders.id) >= 5')
        .includes(:orders) # Avoids N+1 queries when loading order details
    }
  end