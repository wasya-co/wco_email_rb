
namespace :wco_email do

  ##
  ## @stub = WcoEmail::MessageStub.find_by object_key: '2021-10-18T18_41_17Fanand_phoenixwebgroup_co'
  ##
  desc 'churn_n_stubs n=<num> [tagname=<some-new-slug>] [process_images=<false|true>]'
  task churn_n_stubs: :environment do

    ## Usage
    if !ENV['n']
      puts ""
      puts "Usage: churn_n_stubs n=<num> [tagname=<some-new-slug>] [process_images=<false|true>] "
      puts "DOES NOT PRCESS IMAGES BY DEFAULT"
      puts ""
      exit 22
    end

    if ENV['tagname']
      tag = Wco::Tag.find_or_create_by({ slug: ENV['tagname'] })
    end

    process_images = ENV['process_images'] == 'true'
    stub_config = { process_images: process_images }.to_json

    n = ENV['n'].to_i
    stubs = WcoEmail::MessageStub.pending.limit n
    stubs.each_with_index do |stub, idx|
      puts "+++ +++ churning ##{idx+1}"

      stub.tags.push( tag ) if tag
      stub.config = stub_config
      stub.save!

      WcoEmail::MessageIntakeJob.perform_sync( stub.id.to_s )
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

end




