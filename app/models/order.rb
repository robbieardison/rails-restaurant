class Order < ApplicationRecord
    belongs_to :customer
    has_many :order_items
    
    enum :status, { pending: 0, preparing: 1, ready: 2, delivered: 3 }
    
    # Scope to filter by status
    scope :by_status, ->(status) { where(status: status) if status.present? }
  end