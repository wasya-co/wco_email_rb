
class WcoEmail::ApplicationController < Wco::ApplicationController
  before_action :set_lists
  layout 'wco_email/application'


  ##
  ## private
  ##
  private

  # def set_lists
  #   @tags = Wco::Tag.all
  # end

end
