
Wco::Obf ||= Wco::ObfuscatedRedirect

class WcoEmail::ApplicationController < Wco::ApplicationController

  layout 'wco_email/application'

  def config_page
    authorize! :config, WcoEmail
  end

  ##
  ## private
  ##
  private


  def set_lists
    @tags_list = Wco::Tag.list
  end

end
