
require 'aws-sdk-s3'
require 'mail'

def do_process message, client
  the_mail       = Mail.new(message)
  filename       = the_mail.date.in_time_zone.to_s[0..18].gsub(' ', 'T').gsub(':', '_')
  filename       = "#{filename}F#{the_mail.from[0].sub('@', '_').gsub('.', '_')}"
  flag = client.put_object({ bucket: ::S3_CREDENTIALS[:bucket_ses],
    key: filename,
    body: message,
  })
  @stub = WcoEmail::MessageStub.create({
    object_key:  filename,
    status:      WcoEmail::MessageStub::STATUS_PENDING,
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

    client ||= Aws::S3::Client.new({
      region:            ::S3_CREDENTIALS[:region_ses],
      access_key_id:     ::S3_CREDENTIALS[:access_key_id_ses],
      secret_access_key: ::S3_CREDENTIALS[:secret_access_key_ses],
    })

    which_file = ENV['mbox_path']
    message    = nil

    import_tag = Wco::Tag.find_or_create_by({ slug: '20231228-import' })

    File.readlines( which_file, encoding: "ISO8859-1" ).each do |line|
      if (line.match(/\AFrom /))

        if message
          do_process message, client
          print '.'
        end
        message = ''

      else
        message << line.sub(/^\>From/, 'From')
      end
    end

    if message
      do_process message, client
      print '.'
    end
    message = ''

    puts "ok"
  end

  desc 'churn one'
  task churn_one: :environment do
    # @stub = MsgStub.where({ status: 'status_pending' }).first
    @stub = WcoEmail::MessageStub.find_by object_key: '2021-10-18T18_41_17Fanand_phoenixwebgroup_co'
    WcoEmail::MessageIntakeJob.perform_sync( @stub.id.to_s )
  end


end




