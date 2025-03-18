class OrdersController < ApplicationController
    before_action :authenticate_staff!
    
    def index
      @orders = Order.includes(:customer)
      
      # Apply status filter if provided
      if params[:status].present?
        @orders = @orders.by_status(params[:status])
      end
      
      # Default sorting by created_at
      @orders = @orders.order(created_at: :desc)
    end
    
    def show
      @order = Order.includes(:customer, :order_items).find(params[:id])
    end
    
    def update
      @order = Order.find(params[:id])
      
      if @order.update(order_params)
        redirect_to @order, notice: 'Order status updated successfully.'
      else
        render :show
      end
    end
    
    private
    
    def order_params
      params.require(:order).permit(:status)
    end
  end