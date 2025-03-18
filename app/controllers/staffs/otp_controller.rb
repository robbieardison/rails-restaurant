class Staffs::OtpController < ApplicationController
    def new
      # Show OTP input form
      redirect_to new_staff_session_path unless session[:staff_id_for_otp].present?
    end
    
    def create
      @staff = Staff.find_by(id: session[:staff_id_for_otp])
      
      if @staff && @staff.verify_otp(params[:otp_code])
        # Sign in the staff
        sign_in(:staff, @staff)
        
        # Remember this device if requested
        if params[:remember_device] == '1'
          token = SecureRandom.hex(24)
          @staff.remember_device(token)
          cookies.signed[:mfa_device_token] = {
            value: token,
            expires: 30.days.from_now,
            httponly: true,
            secure: Rails.env.production?
          }
        end
        
        # Clear session data
        session.delete(:staff_id_for_otp)
        
        redirect_to after_sign_in_path_for(@staff)
      else
        flash.now[:alert] = "Invalid or expired verification code"
        render :new
      end
    end
  end