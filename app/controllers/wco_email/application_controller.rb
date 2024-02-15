
EC   ||= WcoEmail::Conversation
EF   ||= WcoEmail::EmailFilter
EM   ||= WcoEmail::Message
ET   ||= WcoEmail::EmailTemplate
MS   ||= WcoEmail::MessageStub
EMS  ||= MS
OA   ||= Wco::OfficeAction
OAT  ||= Wco::OfficeActionTemplate
OATT ||= Wco::OfficeActionTemplateTie
Sch  ||= WcoEmail::EmailAction

class WcoEmail::ApplicationController < Wco::ApplicationController

  layout 'wco_email/application'


  ##
  ## private
  ##
  private

  ## Nothing should be here.
  def set_lists
  end

end
