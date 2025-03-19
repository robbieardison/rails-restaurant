# config/environments/production.rb
Rails.application.configure do
  # Enable caching
  config.action_controller.perform_caching = true
  config.cache_store = :redis_cache_store, { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/1') }
  
  # Compress responses
  config.middleware.use Rack::Deflater
  
  # Eager load all classes
  config.eager_load = true
  
  # Enable HTTP/2
  config.action_dispatch.http_cache_control = 'public, max-age=3600'
  
  # CDN support
  config.action_controller.asset_host = ENV['ASSET_HOST'] if ENV['ASSET_HOST']
end