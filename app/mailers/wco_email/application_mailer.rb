
class WcoEmail::ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  def forwarder_notify what
  end

end
