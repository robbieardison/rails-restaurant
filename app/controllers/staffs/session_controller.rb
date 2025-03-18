class Staffs::SessionsController < Devise::SessionsController
    def create
      self.resource = warden.authenticate!(auth_options)
      
      # Check if user needs OTP verification
      if resource.needs_otp_verification?
        # Check if this device is remembered
        device_token = cookies.signed[:mfa_device_token]
        
        if device_token.present? && resource.device_remembered?(device_token)
          # Skip OTP for remembered device
          sign_in(resource_name, resource)
          respond_with resource, location: after_sign_in_path_for(resource)
        else
          # Send OTP email
          StaffMailer.otp_email(resource, resource.otp.now).deliver_now
          
          # Store ID in session for the second step
          session[:staff_id_for_otp] = resource.id
          
          # Redirect to OTP verification page
          redirect_to staff_otp_path
        end
      else
        # Normal sign in
        sign_in(resource_name, resource)
        respond_with resource, location: after_sign_in_path_for(resource)
      end
    end
  end