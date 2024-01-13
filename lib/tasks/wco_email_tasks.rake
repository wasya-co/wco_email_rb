
namespace :wco_email do

  ##
  ## @stub = WcoEmail::MessageStub.find_by object_key: '2021-10-18T18_41_17Fanand_phoenixwebgroup_co'
  ##
  desc 'churn_n_stubs n=<num> [tagname=<some-new-slug>] [process_images=<false|true>] [status=<status>]'
  task churn_n_stubs: :environment do
    puts! ENV, 'ENV'

    ## Usage
    if !ENV['n']
      puts ""
      puts "Usage: churn_n_stubs n=<num> [tagname=<some-new-slug>] [process_images=<false|true>] [status=<status>] "
      puts "DOES NOT PROCESS IMAGES BY DEFAULT"
      puts "status can be something other than STATUS_PENDING"
      puts ""
      exit 22
    end

    if ENV['tagname']
      tag = Wco::Tag.find_or_create_by({ slug: ENV['tagname'] })
    end

    process_images = ENV['process_images'] == 'true'

    status = ENV['status']
    status ||= WcoEmail::MessageStub::STATUS_PENDING

    n = ENV['n'].to_i
    stubs = WcoEmail::MessageStub.where( status: status ).limit(n)
    stubs.each_with_index do |stub, idx|
      puts "+++ +++ churning ##{idx+1} object_key: #{stub.object_key}"

      stub.tags.push( tag ) if tag
      stub.config = JSON.parse( stub.config ).merge({ process_images: process_images, skip_notification: true }).to_json
      stub.save!

      WcoEmail::MessageIntakeJob.perform_sync( stub.id.to_s )
    end
  end

  ##
  ## 2024-01-10
  ## WcoEmail::MessageStub.all.update_all({ bucket: 'ish-ses-2024' })
  ## WcoEmail::MessageIntakeJob.perform_sync( stub.id.to_s )
  ##
  desc 'import objectkey list'
  task import_objectkey_list: :environment do

    # bucket = 'ish-ses'
    bucket = 'ish-test-2024'
    client ||= Aws::S3::Client.new({
      region:            ::S3_CREDENTIALS[:region_ses],
      access_key_id:     ::S3_CREDENTIALS[:access_key_id_ses],
      secret_access_key: ::S3_CREDENTIALS[:secret_access_key_ses],
    })

    # lines = File.read( './data/20240110_ish-ses_objectkeys' )
    lines = File.read( './data/out_head' )
    lines.split("\n").each_with_index do |line, idx|

        object_key = line.split.last
        stub = WcoEmail::MessageStub.create( object_key: object_key, bucket: bucket )
        if stub.persisted?
          print "#{idx+1}."
        else
          puts! stub.errors.full_messages.join(", ")
        end

    end
  end

  desc "Usage: wco_email:mbox_info mbox_path=<filepath> "
  task mbox_info: :environment do

    ## Usage
    if !ENV['mbox_path']
      puts ""
      puts "Usage: wco_email:mbox_info mbox_path=<filepath> "
      puts ""
      exit 22
    end

    mbox_path = ENV['mbox_path']

    out   = File.read(mbox_path, encoding: "ISO8859-1" )
    count = out.scan(/^From /).size

    puts! count, 'count'
  end

  ## Not used until I revisit it. _vp_ 2023-04-02
  desc 'wco_email:mbox2stubs mbox_path=<filepath> tagname=<some-new-slug> skip=0'
  task mbox2stubs: :environment do

    ## Usage
    if !ENV['mbox_path'] || !ENV['tagname']
      puts ""
      puts "Usage: wco_email:mbox2stubs mbox_path=<filepath> tagname=<some-new-slug> "
      puts ""
      exit 22
    end

    WcoEmail::MessageStub.mbox2stubs ENV['mbox_path'], tagname: ENV['tagname'], skip: ENV['skip'].to_i

    puts "ok"
  end

  desc 'remove duplicates of stubs'
  task remove_stub_duplicates: :environment do
    outs = WcoEmail::MessageStub.collection.aggregate([
      {"$group" => { "_id" => "$object_key", "count" => { "$sum" => 1 } } },
      {"$match": {"_id" => { "$ne" => nil } , "count" => {"$gt" => 1} } },
      {"$project" => {"object_key" => "$_id", "_id" => 0} }
    ])
    outs = outs.to_a
    outs.each do |out|
      WcoEmail::MessageStub.where( object_key: out['object_key'] )[1].destroy!
      print '.'
    end
  end

  desc 'email actions, send and roll'
  task run_email_actions: :environment do
    while true do

      WcoEmail::EmailAction.active.where({ :perform_at.lte => Time.now }).each do |sch|
        sch.send_and_roll
        print '^'
      end

      duration = Rails.env.production? ? 120 : 15 # 2 minutes or 15 seconds
      sleep duration
      print '.'

    end
  end

  desc 'send contexts'
  task send_contexts: :environment do
    while true do

      ctxs = WcoEmail::Context.scheduled.notsent
      ctxs.map do |ctx|

        unsub = WcoEmail::Unsubscribe.where({ lead_id: ctx.lead_id, template_id: ctx.email_template_id }).first
        if unsub
          puts! 'This user is unsubscribed; the context cannot be sent.' if DEBUG
          # Office::AdminMessage.create({ message: "Lead `#{ctx.lead.full_name}` [mailto:#{ctx.lead.email}] has already unsubscribed from template `#{Ish::EmailTemplate.find( ctx.email_template_id ).slug}` ." })
          email_action_template_ids = WcoEmail::EmailActionTemplate.where({ email_template_id: ctx.email_template_id }).map(&:id)
          schs = WcoEmail::EmailAction.active.where({
            lead_id: ctx.lead_id,
            :email_action_template_id.in => email_action_template_ids,
          })
          schs.update({ status: WcoEmail::EmailAction::STATUS_UNSUBSCRIBED })
          ctx.update({
            unsubscribed_at: Time.now.to_s,
          })
        else
          out = WcoEmail::ApplicationMailer.send_context_email( ctx[:id].to_s )
          Rails.env.production? ? out.deliver_later : out.deliver_now
        end

        print '^'
      end

      duration = Rails.env.production? ? 120 : 15 # 2 minutes or 15 seconds
      sleep duration
      print '.'

    end
  end

end
