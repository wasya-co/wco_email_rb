
module Wco; end
module WcoEmail; end

class WcoEmail::Engine < ::Rails::Engine
  isolate_namespace WcoEmail
  isolate_namespace Wco
end
