class Api::V1::ReservationsController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_customer!
    
    def create
      @reservation = current_customer.reservations.build(reservation_params)
      
      if @reservation.save
        render json: @reservation, status: :created
      else
        render json: { errors: @reservation.errors }, status: :unprocessable_entity
      end
    end
    
    def index
      @reservations = current_customer.reservations
      render json: @reservations
    end
    
    private
    
    def reservation_params
      params.require(:reservation).permit(:table_number, :reserved_at)
    end
    
    def authenticate_customer!
      # Same as in orders controller
      api_key = request.headers['X-API-Key']
      @current_customer = Customer.find_by(api_key: api_key)
      
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_customer
    end
    
    def current_customer
      @current_customer
    end
end