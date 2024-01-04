
module Pi
end

class Pi::Sitemap

  DEFAULT_ORIGIN = 'https://piousbox.com'

  def checks
    out = [
    #   { path: '/2022/09/sturfee-build-pipeline',       selector: 'article.wco-id-100' },
    # ]; tmp = [

      ##
      ## numbers
      ##
      { path: '/2021/06/2399',       selector: 'article.post-2399' },
      { path: '/2022/03/bundler-and-private-repositories',            redirect_to: 'https://wasyaco.com/2022/03/bundler-and-private-repositories' },
      { path: '/2022/03/ruby-on-rails-allow-parameters-to-have-dot',  redirect_to: 'https://wasyaco.com/2022/03/ruby-on-rails-allow-parameters-to-have-dot' },
      { path: '/2022/03/ruby-on-rails-allow-parameters-to-have-dot/', redirect_to: 'https://wasyaco.com/2022/03/ruby-on-rails-allow-parameters-to-have-dot' },
      { path: '/2022/12/japan-securities-clearing-corp-jscc-issues-emergency-margin-call/',       selector: 'article.post-7033' },
      { path: '/2022/08/convert-wireframe-edges-to-a-model-in-maya/', selector: 'article.post-5854' },
      { path: '/2023/10/does-using-cannabis-lower-blood-pressure', selector: 'article[data-history-node-id="68"]' },

      { path: '/2023/08/what-stocks/', selector: 'article[data-history-node-id="88"]' },

      # /2023/08/fed-chair-jerome-powell-we-have-tightened-policy-significantly-over-the-past-year-inflation-has-moved-down-from-its-peak-it-remains-too-high-we-are-prepared-to-raise-rates-further-if-app/
      # /2023/08/sam-zeloof-makes-cpus-in-his-garage/
      # /2023/04/the-letter-to-pause-ai-development-is-a-power-grab-by-the-elites/

      # /2023/01/a-gentle-minimalist-intro-to-machine-learning

      ##
      ## A
      ##

      # /about

      ##
      ## C
      ##

      { path: '/contact-us', selector: 'article[data-history-node-id="82"]' },

      ##
      ## I
      ##
      { path: '/index.php?p=2399',       redirect_to: '/2021/06/2399' },
      { path: '/index.php?p=7033',       redirect_to: '/2022/12/japan-securities-clearing-corp-jscc-issues-emergency-margin-call/' },

      { path: '/issues/2023q4-issue', selector: 'article[data-history-node-id="4"]' },

      ##
      ## P
      ##

      # /pages/recruiter-intake-form
      { path: '/pages/bookshelf', selector: 'article[data-history-node-id="83"]' },

      ##
      ## S
      ##

      # /sections/technology
      # /sections/ai-ml
      # /sections/markets-trading

      ##
      ## T
      ##

      { path: '/tags/health', selector: '#taxonomy-term-47' },

    ]
    return out
  end
end



