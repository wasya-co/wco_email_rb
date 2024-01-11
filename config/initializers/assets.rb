
Rails.application.config.assets.version = '1.0'

Rails.application.config.assets.precompile += %w(
  wco_models/application.js
  wco_models/application.css

  wco_email/application.js
  wco_email/application.css
);
