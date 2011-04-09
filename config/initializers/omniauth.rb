Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env == "production"
    provider :CMU, :host => 'cmuis.org', :appid => 'teudu', :keyfile => '/usr/local/pubcookie/keys/cmuis.org'
  end
end
