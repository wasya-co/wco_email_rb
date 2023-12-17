
require 'cancancan'
require 'haml'

require "wco_email/engine"

## From: https://github.com/rails/rails/issues/30701
def logger; Rails.logger; end

require 'ish_models'

module Wco; end
module WcoEmail; end

def puts! a, b=''
  puts "+++ +++ #{b}:"
  puts a.inspect
end
