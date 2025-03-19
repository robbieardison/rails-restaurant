# app/controllers/reservations_controller.rb
class ReservationsController < ApplicationController
    before_action :authenticate_staff!
    
    def index
      @reservations = if params[:date].present?
        date = Date.parse(params[:date])
        Reservation.where('DATE(reserved_at) = ?', date).order(:reserved_at)
      else
        Reservation.confirmed_today
      end
    end
    
    def update
      @reservation = Reservation.find(params[:id])
      
      if @reservation.update(reservation_params)
        redirect_to reservations_path, notice: 'Reservation updated successfully'
      else
        render :edit
      end
    end
    
    private
    
    def reservation_params
      params.require(:reservation).permit(:status)
    end
end