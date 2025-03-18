class StaffMailer < ApplicationMailer
    def otp_email(staff, otp_code)
      @staff = staff
      @otp_code = otp_code
      mail(to: staff.email, subject: 'Your one-time verification code')
    end
  end