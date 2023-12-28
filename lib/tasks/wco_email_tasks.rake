require 'aws-sdk-s3'

client = Aws::S3::Client.new({
  region:            ::S3_CREDENTIALS[:region_ses],
  access_key_id:     ::S3_CREDENTIALS[:access_key_id_ses],
  secret_access_key: ::S3_CREDENTIALS[:secret_access_key_ses],
})

def do_process message
  the_mail       = Mail.new(message)
  filename       = the_mail.date.in_time_zone.to_s[0..18].gsub(' ', 'T').gsub(':', '_')
  filename       = "#{filename}F#{the_mail.from[0].sub('@', '_').gsub('.', '_')}"
  flag = client.put_object({ bucket: ::S3_CREDENTIALS[:bucket_ses],
    key: filename,
    body: message,
  })
  @stub = WcoEmail::MessageStub.create({
    object_key:  filename,
    object_path: "https://#{::S3_CREDENTIALS[:bucket_ses]}.s3.amazonaws.com/#{filename}",
    state:       WcoEmail::MessageStub::STATE_PENDING,
  })
  if @stub.persisted?
    # WcoEmail::MessageIntakeJob.perform_later( @stub.id.to_s )
  else
    puts! @stub.errors.full.messages.join(", "), "111 Cannot save this stub: #{@stub.id}."
  end
end

namespace :wco_email do

  desc "seed"
  task seed: :environment do
    inbox = Wco::Tag.find_or_create_by({ slug: 'inbox' })
    trash = Wco::Tag.find_or_create_by({ slug: 'trash' })
  end

  ## Not used until I revisit it. _vp_ 2023-04-02
  desc 'wco_email:churn_mbox mbox_path=<filepath> '
  task churn_mbox: :environment do

    ## Usage
    if !ENV['mbox_path']
      puts ""
      puts "Usage: wco_email:churn_mbox mbox_path=<filepath> "
      puts ""
      exit 22
    end

    which_file = ENV['mbox_path']
    message    = nil

    import_tag = Wco::Tag.create!({ slug: '20231228-import' })

    File.readlines( which_file, encoding: "ISO8859-1" ).each do |line|
      if (line.match(/\AFrom /))

        if message
          do_process message
          print '.'
        end
        message = ''

      else
        message << line.sub(/^\>From/, 'From')
      end
    end

    if message
      do_process message
      print '.'
    end
    message = ''

    puts "ok"
  end



end












  ## Not used until I revisit it. _vp_ 2023-04-02
  # desc 'after lambda puts object_key in mdb'
  # task churn_messages: :environment do
  #   Office::EmailMessageStub.pending.each do |msg|
  #     Ishapi::EmailMessageIntakeJob.process_later( msg.id )
  #   end
  # end

  # desc 'be rake email:churn_one key_id=0ijbh58ocnat5oal6iqchn4rosj9q99u3opq37o1'
  # task churn_one: :environment do
  #   object_key = ENV['key_id'] || 'iao4kfrcot6d3pd3hqp9af21e28iev6b5eoi6781'
  #   stub = MsgStub.find_or_create_by({ object_key: object_key }).update({ state: 'state_pending' })
  #   stub = MsgStub.find_by({ object_key: object_key })
  #   EIJ.new.perform( stub.id )
  # end