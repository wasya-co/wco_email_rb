
Wco::Obf ||= Wco::ObfuscatedRedirect

class WcoEmail::ApplicationController < Wco::ApplicationController

  layout 'wco_email/application'


  ##
  ## private
  ##
  private


  def set_lists
    @tags_list = Wco::Tag.list
  end

end
