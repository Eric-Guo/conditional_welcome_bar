Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/api/active_bars/*', headers: :any, methods: [:get, :options, :head]
  end

  allow do
    origins ENV['CORS_ORIGINS']
    resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end