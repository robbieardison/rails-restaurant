class Reservation < ApplicationRecord
    belongs_to :customer
    
    enum :status, { pending: 0, confirmed: 1, cancelled: 2 }
    
    validates :table_number, :reserved_at, presence: true
    validates :table_number, numericality: { only_integer: true, greater_than: 0 }
    
    # Ensure reservation is at least 1 hour in the future
    validate :must_be_future_reservation
    
    # Ensure table is not double-booked
    validate :no_overlapping_reservations
    
    # Scope for today's confirmed reservations
    scope :confirmed_today, -> {
      where(status: :confirmed)
        .where('DATE(reserved_at) = ?', Date.today)
        .order(:reserved_at)
    }
    
    private
    
    def must_be_future_reservation
      if reserved_at.present? && reserved_at < 1.hour.from_now
        errors.add(:reserved_at, "must be at least 1 hour in the future")
      end
    end
    
    def no_overlapping_reservations
      return unless table_number.present? && reserved_at.present?
      
      # Consider a reservation to occupy a table for 2 hours
      reservation_end = reserved_at + 2.hours
      
      overlapping = Reservation.where(table_number: table_number)
                               .where.not(id: id) # Exclude self when updating
                               .where.not(status: :cancelled)
                               .where('reserved_at < ? AND (reserved_at + INTERVAL \'2 hours\') > ?', 
                                      reservation_end, reserved_at)
      
      if overlapping.exists?
        errors.add(:base, "This table is already reserved during this time period")
      end
    end
  end