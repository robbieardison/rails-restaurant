class ApplicationController < ActionController::Base
  def authenticate_staff!
    redirect_to new_staff_session_path unless staff_signed_in?
  end
end