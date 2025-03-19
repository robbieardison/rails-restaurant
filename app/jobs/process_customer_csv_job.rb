class ProcessCustomerCsvJob
  include Sidekiq::Worker
  sidekiq_options retry: 3
  
  def perform(csv_path)
    require 'csv'
    
    begin
      results = { processed: 0, errors: [] }
      
      CSV.foreach(csv_path, headers: true) do |row|
        # Basic sanitization of inputs
        sanitized_data = row.to_h.transform_values { |v| v.to_s.strip }
        
        # Create customer record with validation
        customer = Customer.new(
          name: sanitized_data['name'],
          email: sanitized_data['email'],
          phone: sanitized_data['phone'],
          address: sanitized_data['address']
        )
        
        if customer.save
          results[:processed] += 1
        else
          results[:errors] << { 
            row: row.to_h, 
            errors: customer.errors.full_messages 
          }
        end
      end
      
      # Log results for admin review
      Rails.logger.info "CSV Import Results: #{results.to_json}"
      
    rescue => e
      Rails.logger.error "CSV Import Error: #{e.message}"
      raise e # Re-raise to trigger Sidekiq retry
    ensure
      # Clean up temporary file
      File.delete(csv_path) if File.exist?(csv_path)
    end
  end
  
  private
  
  def sanitize_csv_value(value)
    return nil if value.nil?
    
    # Remove any potentially dangerous characters
    value = value.to_s.gsub(/[^\w\s@.-]/, '')
    
    # Prevent SQL injection by escaping quotes
    value = ActiveRecord::Base.connection.quote_string(value)
    
    value.strip
  end
end