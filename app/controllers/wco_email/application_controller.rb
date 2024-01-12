
class WcoEmail::ApplicationController < Wco::ApplicationController
  before_action :set_lists
  layout 'wco_email/application'


  ##
  ## private
  ##
  private

  ## Nothing should be here.
  def set_lists
  end

end
