
class WcoEmail::EmailCampaignJob
  include Sidekiq::Job

  sidekiq_options queue: 'wco_email_rb'

  def perform id
    @campaign = WcoEmail::Campaign.find id
    @campaign.do_send
    @campaign.update_attributes({
      status: 'inactive',
      sent_at: Time.now,
    })
  end

end
