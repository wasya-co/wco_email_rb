require 'redd'

namespace :reddit do

  desc "reddit crawler 1 - sentiment of gmejungle ?"
  task :crawl_1 => :environment do
    session = Redd.it({
      user_agent: 'Redd:IshBot:v0.0.0',
      client_id:  'P9eHGjMQ6Ra2nU1vnJy10w',
      secret:     'Hmdy7KTazn9zfpyhNUo6-lAJhHVqmg',
      # username:   ENV['reddit_username'],
      # password:   ENV['reddit_password'],
    })

    top = session.subreddit('gmejungle').top
    submission = top[1]
    byebug
    puts! submission.self_text, 'self text'

  end

end



