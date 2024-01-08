
require 'business_time'

require 'cancancan'

require 'haml'
require 'httparty'

require "wco_email/engine"

## From: https://github.com/rails/rails/issues/30701
def logger; Rails.logger; end

def puts! a, b=''
  puts "+++ +++ #{b}:"
  puts a.inspect
end

ActiveSupport.escape_html_entities_in_json = true
