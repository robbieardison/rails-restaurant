# test/models/reservation_test.rb
require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  setup do
    @customer = Customer.create(name: "John", email: "john@example.com")
  end
  
  test "should not save reservation without table number" do
    reservation = @customer.reservations.build(reserved_at: 2.hours.from_now)
    assert_not reservation.save, "Saved the reservation without a table number"
  end
  
  test "should not save reservation without reserved_at" do
    reservation = @customer.reservations.build(table_number: 1)
    assert_not reservation.save, "Saved the reservation without a reserved_at time"
  end
  
  test "should not save reservation less than 1 hour in the future" do
    reservation = @customer.reservations.build(table_number: 1, reserved_at: 30.minutes.from_now)
    assert_not reservation.save, "Saved the reservation with less than 1 hour in the future"
  end
  
  test "should not save reservation if table is already booked" do
    # Create a reservation for table 1
    @customer.reservations.create(table_number: 1, reserved_at: 5.hours.from_now)
    
    # Try to create another reservation for the same table at the same time
    reservation = @customer.reservations.build(table_number: 1, reserved_at: 5.hours.from_now)
    assert_not reservation.save, "Saved the reservation for a table that's already booked"
  end
  
  test "should save reservation if table is booked but time is different" do
    # Create a reservation for table 1
    @customer.reservations.create(table_number: 1, reserved_at: 5.hours.from_now)
    
    # Create another reservation for the same table but 3 hours later
    reservation = @customer.reservations.build(table_number: 1, reserved_at: 8.hours.from_now)
    assert reservation.save, "Couldn't save the reservation even though the time is different"
  end
  
  test "confirmed_today scope should return only confirmed reservations for today" do
    # Create a confirmed reservation for today
    today = @customer.reservations.create(
      table_number: 1,
      reserved_at: Time.current.change(hour: 18),
      status: :confirmed
    )
    
    # Create a pending reservation for today
    pending = @customer.reservations.create(
      table_number: 2,
      reserved_at: Time.current.change(hour: 19),
      status: :pending
    )
    
    # Create a confirmed reservation for tomorrow
    tomorrow = @customer.reservations.create(
      table_number: 3,
      reserved_at: 1.day.from_now.change(hour: 18),
      status: :confirmed
    )
    
    confirmed_today = Reservation.confirmed_today
    
    assert_includes confirmed_today, today
    assert_not_includes confirmed_today, pending
    assert_not_includes confirmed_today, tomorrow
  end
end