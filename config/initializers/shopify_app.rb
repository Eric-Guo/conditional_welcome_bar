# frozen_string_literal: true

ShopifyApp.configure do |config|
  config.application_name = 'eric-test'
  config.api_key = ENV['SHOPIFY_CLIENT_KEY']
  config.secret = ENV['SHOPIFY_CLIENT_SECRET']
  config.old_secret = ""
  config.scope = ENV['SHOPIFY_API_SCOPE']
  config.embedded_app = true
  config.after_authenticate_job = false
  config.api_version = '2019-07'
  config.session_repository = Shop
  config.scripttags = [{
    event: 'onload',
    src: "#{ENV['APP_HOST_URL']}/welcome_bar.js"
  }]
end

# ShopifyApp::Utils.fetch_known_api_versions                        # Uncomment to fetch known api versions from shopify servers on boot
# ShopifyAPI::ApiVersion.version_lookup_mode = :raise_on_unknown    # Uncomment to raise an error if attempting to use an api version that was not previously known
