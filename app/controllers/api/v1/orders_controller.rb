class Api::V1::OrdersController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_customer!
    
    def create
      @order = current_customer.orders.build(order_params)
      
      ActiveRecord::Base.transaction do
        if @order.save
          params[:order_items].each do |item|
            menu_item = MenuItem.find(item[:menu_item_id])
            @order.order_items.create!(
              menu_item: menu_item,
              quantity: item[:quantity],
              unit_price: menu_item.price
            )
          end
          
          # Update order total
          total = @order.order_items.sum(&:subtotal)
          @order.update!(total_amount: total)
          
          render json: @order, status: :created
        else
          render json: { errors: @order.errors }, status: :unprocessable_entity
        end
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Menu item not found" }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
    
    def index
      @orders = current_customer.orders.includes(:order_items)
      render json: @orders
    end
    
    def show
      @order = current_customer.orders.includes(:order_items).find(params[:id])
      render json: @order
    end
    
    private
    
    def order_params
      params.require(:order).permit(:notes)
    end
    
    def authenticate_customer!
      # In a real app, you would implement customer JWT auth or similar
      # For this example, find a customer by API key
      api_key = request.headers['X-API-Key']
      @current_customer = Customer.find_by(api_key: api_key)
      
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_customer
    end
    
    def current_customer
      @current_customer
    end
end