
# Wco::Obf ||= Wco::ObfuscatedRedirect

class WcoEmail::ApplicationController < Wco::ApplicationController

  layout 'wco_email/application'

  before_action :set_lists

  def config_page
    authorize! :config, WcoEmail
  end

  ##
  ## private
  ##
  private

  # def set_lists
  #   super
  # end

end
