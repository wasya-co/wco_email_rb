

require 'httparty'
require 'json'


def puts! args, label=""
  puts "+++ +++ #{label}"
  puts args.inspect
end

namespace :wordpress do

  desc 'post to pi_wp'
  task :post_to_pi_wp => :environment do

    start_date = '2023-01-26'.to_date
    count = 1
    title = "Jan'23 Graphics Gallery"
    gallery_slug = '20230126'
    ## categories
    ## 203 - trees
    ## 197 - jan'23 graphics
    ## 200 - jan'23 NFT's
    categories = 197

    gallery_url = "https://manager.piousbox.com/api/galleries/view/#{gallery_slug}.json"
    pics = HTTParty.get( gallery_url ).body
    pics = JSON.parse( pics )['gallery']['photos']
    pics.each do |pic|
      response = HTTParty.post("#{ENV['WP_HOST']}/wp-json/wp/v2/posts",
        basic_auth: { username: ENV['WP_USERNAME'], password: ENV['WP_PASSWORD'] },
        :headers => { 'Content-Type' => 'application/json', 'Accept' => 'application/json'},
        body: {
          title: "#{title} ##{count}",
          content: "<!--more--><div style='text-align: center'><img src='#{pic['large_url']}' /></div></center>",
          status: 'publish',
          categories: categories,
          date: "#{start_date.to_s}T00:00:00",
          meta: {
            wps_subtitle: "<img src='#{pic['small_url']}' />",
          }
        }.to_json,
        :debug_output => $stdout
      )
      start_date = start_date + 1.day
      count = count + 1
      resp = JSON.parse(response.body)
      puts! resp, 'ze response body'
    end

  end

end