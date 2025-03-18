# Description: Controller for handling customer CSV uploads
# This controller is responsible for handling customer CSV uploads. It includes an action to upload a CSV file containing customer data, which is then processed asynchronously by a Sidekiq job. The job reads the CSV file, sanitizes the input data, and attempts to create customer records based on the data. The job logs the results of the import process, including the number of records processed and any errors encountered during the process. The customer model includes a scope for finding frequent customers based on their order history.
# The controller enforces authentication for staff users before allowing access to the upload action.
# Note: This controller assumes the existence of a Customer model with the appropriate attributes and associations.
# 
# The controller code is as follows:
class CustomersController < ApplicationController
    before_action :authenticate_staff!
    
    def upload_csv
      # Validate file presence
      unless params[:file].present?
        return render json: { error: 'No file uploaded' }, status: :bad_request
      end
      
      # Validate file format
      unless params[:file].content_type == 'text/csv'
        return render json: { error: 'Invalid file format. Please upload a CSV file' }, status: :bad_request
      end
      
      # Validate file size (e.g., limit to 5MB)
      if params[:file].size > 5.megabytes
        return render json: { error: 'File size too large. Limit is 5MB' }, status: :bad_request
      end
      
      # Store file temporarily
      csv_path = Rails.root.join('tmp', "customer_import_#{Time.now.to_i}.csv")
      File.open(csv_path, 'wb') do |file|
        file.write(params[:file].read)
      end
      
      # Queue processing job
      job_id = ProcessCustomerCsvJob.perform_async(csv_path.to_s)
      
      render json: { message: 'CSV upload is being processed', job_id: job_id }, status: :ok
    end
  end