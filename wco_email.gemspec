
Gem::Specification.new do |spec|
  spec.name        = "wco_email"
  spec.version     = "0.1.0.0"
  spec.authors     = [ "Victor Pudeyev" ]
  spec.email       = ["victor@wasya.co"]
  spec.homepage    = "https://wasya.co"
  spec.summary     = "Wco Email"
  spec.description = "The Wco Email client."
  spec.license     = "Proprietary"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = "https://wasya.co"
  spec.metadata["changelog_uri"]   = "https://wasya.co"

  spec.files = Dir["{app,config,db,lib}/**/*", "Rakefile", "README.txt"]

  ##
  ## Edit the template, not the gemspec!
  ##
  spec.add_dependency "rails",      "~> 6.1.7"
  spec.add_dependency "haml",       "~> 6.3.0"
  spec.add_dependency "httparty"

  # spec.add_dependency 'sass-rails', "~> 5.0"
  # spec.add_dependency 'webpacker', "~> 5.4.4"

  spec.add_dependency 'devise',     "~> 4.9.3"
  spec.add_dependency "cancancan",  "~> 3.5.0"

  spec.add_dependency 'wco_models', "~> 3.1.0"

  spec.add_dependency 'mongoid',           '~> 7.3.0'
  spec.add_dependency 'mongoid_paranoia',  '~> 0.6.0'
  spec.add_dependency 'mongoid-autoinc',   '~> 6.0.3'
  spec.add_dependency 'mongoid-paperclip', '~> 0.1.0'
  spec.add_dependency 'kaminari-mongoid',  '~> 1.0.1'
  spec.add_dependency 'kaminari-actionview'

  spec.add_dependency 'aws-sdk-s3'

end
