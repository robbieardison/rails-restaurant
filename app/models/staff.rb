# app/models/staff.rb
class Staff < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  attr_accessor :otp_code
  
  def generate_otp_secret
    self.otp_secret = ROTP::Base32.random
    save
  end
  
  def otp
    ROTP::TOTP.new(otp_secret, issuer: "RestaurantApp")
  end
  
  def verify_otp(code)
    return false unless otp_secret.present?
    return false unless otp.verify(code, drift_behind: 15, drift_ahead: 15)
    
    update(otp_verified_at: Time.current)
    true
  end
  
  def needs_otp_verification?
    otp_secret.present? && (otp_verified_at.nil? || otp_verified_at < 30.minutes.ago)
  end
  
  def remember_device(token)
    update(
      mfa_device_token: token,
      mfa_device_expires_at: 30.days.from_now
    )
  end
  
  def device_remembered?(token)
    mfa_device_token == token && mfa_device_expires_at > Time.current
  end
end