require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  test "should not save customer without email" do
    customer = Customer.new(name: "John")
    assert_not customer.save, "Saved the customer without an email"
  end
  
  test "should not save customer with duplicate email" do
    Customer.create(name: "John", email: "john@example.com")
    customer = Customer.new(name: "Another John", email: "john@example.com")
    assert_not customer.save, "Saved the customer with a duplicate email"
  end
  
  test "should generate API key on create" do
    customer = Customer.create(name: "John", email: "unique@example.com")
    assert_not_nil customer.api_key, "API key was not generated"
  end
  
  test "frequent_customers scope should return customers with 5+ orders in last 30 days" do
    # Create a customer with 5 recent orders
    customer = Customer.create(name: "Frequent", email: "frequent@example.com")
    5.times { customer.orders.create(created_at: 5.days.ago) }
    
    # Create a customer with 4 recent orders (not enough)
    less_frequent = Customer.create(name: "Less Frequent", email: "less@example.com")
    4.times { less_frequent.orders.create(created_at: 5.days.ago) }
    
    # Create a customer with 5 old orders (too old)
    old_customer = Customer.create(name: "Old", email: "old@example.com")
    5.times { old_customer.orders.create(created_at: 35.days.ago) }
    
    frequent_customers = Customer.frequent_customers
    
    assert_includes frequent_customers, customer
    assert_not_includes frequent_customers, less_frequent
    assert_not_includes frequent_customers, old_customer
  end
end