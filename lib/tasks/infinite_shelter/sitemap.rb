
module Ish
end

class Ish::Sitemap

  DEFAULT_ORIGIN = 'https://infiniteshelter.com'

  def checks
    out = [
    #   { path: '/2022/09/sturfee-build-pipeline',       selector: 'article.wco-id-100' },
    # ]; tmp = [


      { path: '/en/locations/show/tomorrowland',       selector: 'body' },
      { path: '/en/locations/show/florida',       selector: 'body' },


    ]
    return out
  end
end



