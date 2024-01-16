
EC  = WcoEmail::Conversation
EF  = WcoEmail::EmailFilter
EM  = WcoEmail::Message
ET  = WcoEmail::EmailTemplate
MS  = WcoEmail::MessageStub
EMS = MS
OA  = Wco::OfficeAction
OAT = Wco::OfficeActionTemplate
Sch = WcoEmail::EmailAction

class WcoEmail::ApplicationController < Wco::ApplicationController
  # before_action :set_lists
  layout 'wco_email/application'


  ##
  ## private
  ##
  private

  ## Nothing should be here.
  def set_lists
  end

end
