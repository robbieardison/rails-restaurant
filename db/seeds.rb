# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create admin staff
Staff.create!(
  email: 'admin@restaurant.com',
  password: 'password123',
  password_confirmation: 'password123'
)

# Create menu items
menu_items = [
  { name: 'Margherita Pizza', description: 'Classic tomato and mozzarella pizza', price: 12.99, available: true },
  { name: 'Pepperoni Pizza', description: 'Pizza with pepperoni and cheese', price: 14.99, available: true },
  { name: 'Caesar Salad', description: 'Fresh romaine lettuce with Caesar dressing', price: 8.99, available: true },
  { name: 'Vegetable Pasta', description: 'Pasta with seasonal vegetables', price: 13.99, available: true },
  { name: 'Grilled Chicken', description: 'Grilled chicken with vegetables', price: 15.99, available: true },
  { name: 'Chocolate Cake', description: 'Rich chocolate cake with ice cream', price: 6.99, available: true },
]

menu_items.each do |item|
  MenuItem.create!(item)
end

# Create some customers
customers = [
  { name: 'John Doe', email: 'john@example.com', phone: '123-456-7890', address: '123 Main St' },
  { name: 'Jane Smith', email: 'jane@example.com', phone: '098-765-4321', address: '456 Oak Ave' },
  { name: 'Bob Johnson', email: 'bob@example.com', phone: '555-123-4567', address: '789 Pine Rd' },
]

customers.each do |customer|
  Customer.create!(customer)
end

# Create sample orders
customers = Customer.all
menu_items = MenuItem.all

customers.each do |customer|
  # Create 2-4 orders for each customer
  rand(2..4).times do
    # Create order with random status
    order = customer.orders.create!(
      status: Order.statuses.keys.sample,
      created_at: rand(1..30).days.ago
    )
    
    # Add 1-5 items to the order
    rand(1..5).times do
      menu_item = menu_items.sample
      order.order_items.create!(
        menu_item: menu_item,
        quantity: rand(1..3),
        unit_price: menu_item.price
      )
    end
    
    # Update order total
    total = order.order_items.sum(&:subtotal)
    order.update!(total_amount: total)
  end
  
  # Create reservations
  if rand < 0.7 # 70% chance of having reservations
    rand(1..3).times do
      reservation_time = rand(1..14).days.from_now.at_beginning_of_day + rand(11..21).hours
      customer.reservations.create!(
        table_number: rand(1..10),
        reserved_at: reservation_time,
        status: Reservation.statuses.keys.sample
      )
    end
  end
end

puts "Seed data created successfully!"