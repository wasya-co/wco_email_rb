
module Bjjc
end

class Bjjc::Sitemap

  DEFAULT_ORIGIN = 'https://bjjcollective.com'

  def checks
    out = [
    #   { path: '/2022/09/sturfee-build-pipeline',       selector: 'article.wco-id-100' },
    # ]; tmp = [


      { path: '/en/locations/show/tomorrowland',       selector: 'body' },
      { path: '/en/locations/show/florida',       selector: 'body' },



      # /technique/guards
      # /technique/guards/closed-guard
      # /technique/guards/open-guard
      # /technique/guards/butterfly-guard
      # /technique/guards/rubber-guard
      # /technique/guards/de-la-riva
      # /technique/guards/reverse-de-la-riva-guard
      # /technique/guards/sleeve-and-collar-guards
      # /technique/guards/spider-guard
      # /technique/guards/turtle-guard
      # /technique/guards/x-guard
      # /technique/guards/half-guard
      # /technique/guards/inverted-guards
      # /technique/guards/koala-guard
      # /technique/guards/misc-guards
      # /technique/mounts
      # /technique/stand-up-gi
      # /technique/stand-up-no-gi
      # /technique/submission-escapes-finishes
      # /technique/sweeps
      # /technique/sweeps/butterfly-sweep
      # /technique/misc


    ]
    return out
  end
end



