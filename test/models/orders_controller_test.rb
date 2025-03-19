# test/controllers/orders_controller_test.rb
require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @staff = Staff.create(email: "staff@example.com", password: "password")
    sign_in @staff
    
    @customer = Customer.create(name: "John", email: "john@example.com")
    @order = @customer.orders.create(status: :pending)
  end
  
  test "should get index" do
    get orders_url
    assert_response :success
  end
  
  test "should get index with status filter" do
    get orders_url, params: { status: "pending" }
    assert_response :success
  end
  
  test "should get show" do
    get order_url(@order)
    assert_response :success
  end
  
  test "should update order status" do
    patch order_url(@order), params: { order: { status: "preparing" } }
    assert_redirected_to order_url(@order)
    
    @order.reload
    assert_equal "preparing", @order.status
  end
  
  test "should not allow access without login" do
    sign_out @staff
    get orders_url
    assert_redirected_to new_staff_session_path
  end
end