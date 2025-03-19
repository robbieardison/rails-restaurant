class DashboardController < ApplicationController
    before_action :authenticate_staff!
    
    def index
      @today_orders = Order.where('created_at >= ?', Date.today).count
      @pending_orders = Order.pending.count
      @today_reservations = Reservation.confirmed_today.count
      @frequent_customers = Customer.frequent_customers.limit(5)
    end
end