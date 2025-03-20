# Description: Controller for handling customer CSV uploads
# This controller is responsible for handling customer CSV uploads. It includes an action to upload a CSV file containing customer data, which is then processed asynchronously by a Sidekiq job. The job reads the CSV file, sanitizes the input data, and attempts to create customer records based on the data. The job logs the results of the import process, including the number of records processed and any errors encountered during the process. The customer model includes a scope for finding frequent customers based on their order history.
# The controller enforces authentication for staff users before allowing access to the upload action.
# Note: This controller assumes the existence of a Customer model with the appropriate attributes and associations.
# 
# The controller code is as follows:
# app/controllers/customers_controller.rb
class CustomersController < ApplicationController
  before_action :authenticate_staff!

  def index
    @customers = Customer.all
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to @customer, notice: 'Customer was successfully created.'
    else
      render :new
    end
  end

  def upload_csv
    # Validate file presence
    unless params[:file].present?
      flash[:alert] = 'No file uploaded'
      return redirect_to new_customer_path  # Or wherever your upload form is
    end

    # Validate file format
    unless params[:file].content_type == 'text/csv'
      flash[:alert] = 'Invalid file format. Please upload a CSV file'
      return redirect_to new_customer_path
    end

    # Validate file size (e.g., limit to 5MB)
    if params[:file].size > 5.megabytes
      flash[:alert] = 'File size too large. Limit is 5MB'
      return redirect_to new_customer_path
    end

    # Store file temporarily
    csv_path = Rails.root.join('tmp', "customer_import_#{Time.now.to_i}.csv")
    File.open(csv_path, 'wb') do |file|
      file.write(params[:file].read)
    end

    # Queue processing job
    job_id = ProcessCustomerCsvJob.perform_async(csv_path.to_s)

    flash[:notice] = 'CSV upload is being processed. Customers will be added shortly.'
    redirect_to customers_path
  #ensure
    # Clean up temporary file even if there are errors
  #  File.delete(csv_path) if File.exist?(csv_path)
  end

  private

  def customer_params
    params.require(:customer).permit(:name, :email, :phone, :address)
  end
end