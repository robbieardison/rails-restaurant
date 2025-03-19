SecureHeaders::Configuration.default do |config|
    config.cookies = {
      secure: true,
      httponly: true,
      samesite: {
        lax: true
      }
    }
    
    config.csp = {
      default_src: %w('self'),
      script_src: %w('self'),
      style_src: %w('self' 'unsafe-inline'),
      font_src: %w('self'),
      connect_src: %w('self'),
      img_src: %w('self' data:),
      frame_src: %w('none'),
      frame_ancestors: %w('none'),
      form_action: %w('self'),
      object_src: %w('none')
    }
end