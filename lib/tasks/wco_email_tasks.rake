
require 'aws-sdk-s3'
require 'mail'

def do_process message, client, tag
  the_mail       = Mail.new(message)
  filename       = the_mail.date.in_time_zone.to_s[0..18].gsub(' ', 'T').gsub(':', '_')
  filename       = "#{filename}F#{the_mail.from[0].sub('@', '_').gsub('.', '_')}"
  puts! filename, 'filename'

  flag = client.put_object({ bucket: ::S3_CREDENTIALS[:bucket_ses],
    key: filename,
    body: message,
  })
  @stub = WcoEmail::MessageStub.create({
    object_key:  filename,
    status:      WcoEmail::MessageStub::STATUS_PENDING,
    tags:        tag ? [ tag ] : [],
  })
  if @stub.persisted?
    # WcoEmail::MessageIntakeJob.perform_later( @stub.id.to_s )
  else
    puts! @stub.errors.full_messages.join(", "), "Cannot save this stub_id: #{@stub.id} object_key: #{filename} "
  end
end

namespace :wco_email do

  desc "seed"
  task seed: :environment do
    inbox = Wco::Tag.find_or_create_by({ slug: 'inbox' })
    trash = Wco::Tag.find_or_create_by({ slug: 'trash' })
  end

  ## Not used until I revisit it. _vp_ 2023-04-02
  desc 'wco_email:mbox2stubs mbox_path=<filepath> [ tagname=<some-new-slug> ] '
  task mbox2stubs: :environment do

    ## Usage
    if !ENV['mbox_path']
      puts ""
      puts "Usage: wco_email:mbox2stubs mbox_path=<filepath> [ tagname=<some-new-slug> ] "
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

    if ENV['tagname']
      tag = Wco::Tag.find_or_create_by({ slug: ENV['tagname'] })
    end

    File.readlines( which_file, encoding: "ISO8859-1" ).each do |line|
      if (line.match(/\AFrom /))

        if message
          do_process message, client, tag
          print '.'
        end
        message = ''

      else
        message << line.sub(/^\>From/, 'From')
      end
    end

    if message
      do_process message, client, tag
      print '.'
    end
    message = ''

    puts "ok"
  end

  ##
  ## @stub = WcoEmail::MessageStub.find_by object_key: '2021-10-18T18_41_17Fanand_phoenixwebgroup_co'
  ##
  desc 'churn_n_stubs n=<num> [tagname=<some-new-slug>] [process_images=<false|true>] '
  task churn_n_stubs: :environment do

    ## Usage
    if !ENV['n']
      puts ""
      puts "Usage: churn_n_stubs n=<num> [tagname=<some-new-slug>] [process_images=<false|true>] "
      puts ""
      exit 22
    end

    if ENV['tagname']
      tag = Wco::Tag.find_or_create_by({ slug: ENV['tagname'] })
    end

    n = ENV['n'].to_i
    stubs = WcoEmail::MessageStub.where({ status: 'status_pending' }).limit n
    stubs.each_with_index do |stub, idx|
      puts "+++ +++ churning ##{idx+1}"

      stub.tags.push( tag )

      if ENV['process_images']
        if ENV['process_images'] == 'false'
          process_images = false
        elsif
          ENV['process_images'] == 'true'
          process_images = true
        end
        stub.config = { process_images: process_images }.to_json
      end

      stub.save

      WcoEmail::MessageIntakeJob.perform_sync( stub.id.to_s )
    end
  end


end




