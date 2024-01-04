
class Wco::Sitemap

  DEFAULT_ORIGIN = 'https://wasyaco.com'

  def checks
    out = [
    #   { path: '/shop/investment-opportunities/8-infinite-business-plan.html', selector: '.product-id-8' },
    # ]; tmp = [

      ##
      ## Digits
      ##
      { path: '/2023q3-issue',                    redirect_to: '/issues/2023q3-issue' },
      { path: '/32-consulting-services',          redirect_to: '/services/consulting' }, ## @TODO: there is no such thing
      { path: '/31-services',                     redirect_to: '/services/consulting' }, ## @TODO: there is no such thing


      { path: '/2022/12/auriculares-tozo-nc2',                    redirect_to: '/' },


      { path: '/2023/03/2023-03-31-site-updates',               selector: 'article.wco-id-130' },
      { path: '/2022/12/soporte-portatil-para-laptops',         selector: 'article#post-3412' },
      { path: '/2022/12/teclado-plegable-portatil',             selector: 'article#post-3417' },
      { path: '/2022/05/20220522-site-updates',                 selector: 'article.wco-id-141' },
      { path: '/2023/01/2023-01-10-site-updates',               selector: 'article.wco-id-133' },
      { path: '/2023/02/firechat-with-an-engineer-what-is-scrum-methodology-in-testing',          selector: 'article#post-3731' },
      { path: '/2022/11/creek-enterprise-the-invoicing-tool-2017',                                selector: 'article#post-3157' },
      { path: '/2023/05/how-to-organize-a-wordpress-blog-into-magazine-like-issues-2',            selector: 'article#post-3239' },
      { path: '/2023/04/what-does-it-mean-when-financial-professionals-say-cash-is-a-position',   selector: 'article#post-3943' },
      { path: '/2022/12/currently-testing-my-todo-list-should-contain-no-more-than-1-elements',   selector: 'article#post-3249' },
      { path: '/2023/08/capistrano-authentication-failed-for-user-ubuntuxx-xxx-xxx-xxx-netsshauthenticationfailed', selector: 'article#post-4376' },
      { path: '/2022/09/20220920-site-updates',                        selector: 'article.wco-id-140' },
      { path: '/2022/10/20220914-infinite-shelter-updates',            selector: 'article.wco-id-139' },
      { path: '/2022/12/samsung-galaxy-a22',                           selector: 'article#post-3392' },
      { path: '/2022/12/announcement-the-team-adds-ai-assisted-writing-capabilities', selector: 'article#post-2997' },
      # /2023/11/our-corporate-culture
      # /2023/11/learn-gpt-architecture-a-minimal-example

      # /2022/10/20220904-infinite-shelter-updates
      # /2023/02/202302-site-updates
      # /2022/12/2022-12-06-site-updates
      # /2022/11/2022-11-22-site-updates
      # /2022/11/2022-11-10-site-updates
      # /2022/10/20221013-site-updates
      # /2023/05/20230518-site-updates
      # /2023/01/a-gentle-minimalist-intro-to-machine-learning

      { path: '/2022/09/sturfee-build-pipeline',                      selector: 'article.wco-id-100' },
      { path: '/2022/03/bundler-and-private-repositories',            selector: 'article.wco-id-112' },
      { path: '/2022/03/ruby-on-rails-allow-parameters-to-have-dot',  selector: 'article.wco-id-100' },
      { path: '/2022/03/ruby-on-rails-allow-parameters-to-have-dot/', selector: 'article.wco-id-100' },
      { path: '/2023/04/a-good-looking-css-only-chip',                selector: 'article.wco-id-101' },
      { path: '/2023/08/navigating-the-gauntlet-hardships-of-acquiring-technical-talent-for-software-development-startups', selector: 'article.post-4378' },
      { path: '/2023/09/notes-on-naming-conventions',                 selector: 'article.wco-id-109' },
      { path: '/2023/11/open-source-contribution-drupal-module-consent_popup', selector: 'article[data-history-node-id="154"]' },



      ##
      ## C
      ##

      { path: '/case-studies',                 redirect_to: '/categories/case-studies' },
      { path: '/consulting-services',          redirect_to: '/services/consulting' },
      { path: '/contact-us',                   redirect_to: '/contact-us/contact-us-step1' },
      { path: '/contact-us-2',                 redirect_to: '/contact-us/project-intake' },
      { path: '/contact-us-3',                 redirect_to: '/contact-us/contact-us-step-1' },
      { path: '/contact-us-4',                 redirect_to: '/contact-us/contact-us-step-1' },
      { path: '/contact-us/send-message',      redirect_to: '/contact-us/project-intake' },


      { path: '/careers',                                              selector: 'article[data-history-node-id="124"]' },
      { path: '/careers/submit-resume',                                selector: 'article[data-history-node-id="124"]' },
      { path: '/categories/2023q3-issue/202305-software-architecture', selector: 'body.category-126' },
      { path: '/categories/2023q2-issue/2023q2-site-updates',          selector: 'body.category-112' },
      { path: '/categories/case-studies',                              selector: '.category-case-studies' },
      { path: '/categories/uncategorized',                             selector: 'body.category-1' },
      { path: '/contact-us/contact-us-step1',                          selector: '.contact-us-4-step1', },
      { path: '/contact-us/project-intake',
        # selector: 'article[data-history-node-id="79"]' },
        selector: '#mauticform_wrapper_projectintake',
      },

      ##
      ## D
      ##

      { path: '/design-services',   redirect_to: '/services/graphic-design' },
      { path: '/dev-js',            redirect_to: '/services/javascript-development' },
      { path: '/dev-react',         redirect_to: '/services/reactjs-development' },
      { path: '/dev-ror',           redirect_to: '/services/ruby-on-rails-web-application-development' },
      { path: '/dev-php',           redirect_to: '/services/php-development' },
      { path: '/dev-wp',            redirect_to: '/services/wordpress-development' },

      # /donate
      # /donate/with-paypal
      # /donate/with-email-and-message

      { path: '/documentation',               selector: 'article[data-history-node-id="119"]' },
      { path: '/documentation/basic-setup',   selector: 'article[data-history-node-id="119"]' },

      ##
      ## E
      ##

      { path: '/es/paginas',                        selector: 'article[data-history-node-id="102"]' },
      { path: '/es/paginas/terminos-y-condiciones', selector: 'article[data-history-node-id="14"]' },
      { path: '/es/pimsleur-ingles-para-espanol',   selector: 'body.page-id-3291', private: true },

      ##
      ## H
      ##

      # /hosted-appliances/
      # /hosted-appliances/jenkins
      # /hosted-appliances/matomo-analytics
      # /hosted-appliances/redmine

      ##
      ## I
      ##

      { path: '/issues',                 selector: 'body.page-id-4022' },
      { path: '/issues/2023q3-issue',
        selector: 'article#a2023q3issue',
        selectors: [ 'section.issues-navigator' ],
        meta_description: 'Wasya Co - Application Prototyping & Rapid Software Development',
      },
      { path: '/issues/2023q4-issue',
        selector: 'article#a2023q4issue',
      },
      # /issues/2024q1-issue/newsfeed

      ##
      ## O
      ##

      { path: '/our-services-2',                             redirect_to: '/our-services' },
      { path: '/our-services-reactjs',                       redirect_to: '/reactjs-development-services' },
      { path: '/our-process',                                redirect_to: '/our-process-2' },
      { path: '/our-services',                               redirect_to: '/services' },
      { path: '/our-services/application-layer-development', redirect_to: '/services' },
      # /our-work

      { path: '/our-process-2',                              selector: 'article[data-history-node-id="77"]' },

      ##
      ## P
      ##

      { path: '/pages/terms-of-service',         redirect_to: '/pages/terms-and-conditions' },
      { path: '/project-intake',                 redirect_to: '/contact-us/project-intake' },
      { path: '/project-intake-1',               redirect_to: '/contact-us/project-intake' },
      { path: '/pudeyev-resume-2',               redirect_to: '/pudeyev-resume' },

      { path: '/pages',                         selector: 'article[data-history-node-id="103"]' },
      { path: '/pages/terms-and-conditions',    selector: 'article[data-history-node-id="14"]' },
      { path: '/pages/our-commitment-to-employees-personal-growth-career-growth-and-continuous-learning', selector: 'article[data-history-node-id="104"]' },
      { path: '/pages/privacy-policy',          selector: 'article[data-history-node-id="105"]' },
      { path: '/pages/thank-you',               selector: 'article[data-history-node-id="106"]' },
      { path: '/pages/vaccine-policy',          selector: 'article[data-history-node-id="107"]' },
      { path: '/pages/workplace-policy',        selector: 'article[data-history-node-id="108"]' },

      { path: '/products',                      selector: 'article[data-history-node-id="92"]' },
      { path: '/products/piousbox-crm',         selector: 'article[data-history-node-id="95"]' },
      # { path: '/products/us-business-for-sale', selector: 'article[data-history-node-id="90"]' },

      { path: '/pudeyev-resume',                selector: 'body.page-id-2880' },

      { path: '/pages/investors',        selector: 'article[data-history-node-id="127"]' },
      { path: '/pages/our-team',         selector: 'article[data-history-node-id="113"]' },
      { path: '/pages/public-relations', selector: 'article[data-history-node-id="115"]' },

      ##
      ## S
      ##

      { path: '/services/ruby-on-rails', redirect_to: '/services/ruby-on-rails-web-application-development' },

      # /services/ab-testing-ruby-on-rails-a-b
      # /services/59-custom-logo-design.html
      # /services/60-illustration.html
      # /services/64-3d-object-design.html
      # /services/graphic-design
      # /services/single-sign-on - but should really be products, not services.

      { path: '/services/hosted-appliances',        selector: 'article[data-history-node-id="127"]' },
      { path: '/services/owasp-security-audit',     selector: 'article[data-history-node-id="88"]' },

      # /services/web-analytics
      # /services/document-signing

      { path: '/services',                                           selector: 'article[data-history-node-id="89"]' },
      # { path: '/services/ai-ml-development',                         selector: '.Service' },
      # { path: '/services/consulting',                                selector: '.Service' },
      # { path: '/services/design',                                    selector: '.Service' },
      # { path: '/services/javascript-development',                    selector: '.Service' },
      { path: '/services/php-development',                           selector: 'article[data-history-node-id="83"]' },
      { path: '/services/reactjs-development',                       selector: 'article[data-history-node-id="82"]' },
      { path: '/services/ruby-on-rails-web-application-development', selector: 'article[data-history-node-id="99"]' },
      { path: '/services/ssl-certificate-installation-management',   selector: 'article[data-history-node-id="21"]' },
      { path: '/services/wordpress-development',                     selector: 'article[data-history-node-id="20"]' },

      { path: '/shop',                                                        selector: 'body#index' },
      { path: '/shop/3-stl-prints',                                           selector: 'body.category-id-3' },
      { path: '/shop/4-downloads',                                            selector: 'body.category-id-4' },
      { path: '/shop/5-services',                                             selector: 'body.category-id-5' },
      { path: '/shop/downloads/2-victor-pudeyev-resume.html',                 selector: 'body.product-id-2' },
      { path: '/shop/investment-opportunities/8-infinite-business-plan.html', selector: 'body.product-id-8' },
      { path: '/shop/services/5-mentorship-30min.html',                       selector: 'body.product-id-5' },
      { path: '/shop/services/6-mentorship-1hr.html',                         selector: 'body.product-id-6' },
      { path: '/shop/services/7-interview-90min.html',                        selector: 'body.product-id-7' },
      { path: '/shop/stl-prints/1-stylus-holder.html',                        selector: 'body.product-id-1' },


      ##
      ## T
      ##

      # /tags/ai-ml
      # /tags/case-studies
      # /tags/css
      # /tags/corporate-governance
      # /tags/devops
      # /tags/drupal-tutorials
      # /tags/engineering-blog
      # /tags/human-resources
      # /tags/infinite-business-plan
      # /tags/our-work
      # /tags/react-js
      # /tags/scrum
      # /tags/tutorials
      # /tags/uiux
      # /tags/open-source-contributions
      { path: '/tags/2023q1-issue',     selector: '#taxonomy-term-25' },
      # /tags/documentation



      { path: '/thank-you',                 redirect_to: '/pages/thank-you' },

      { path: '/tags/cyber-security',   selector: '#taxonomy-term-27' },
      { path: '/tags/ruby-on-rails',    selector: '#taxonomy-term-17' },
      { path: '/tags/site-updates',     selector: '#taxonomy-term-3' },

      ##
      ## U
      ##

      { path: '/unsubscribe-1', redirect_to: '/unsubscribe' },

      { path: '/unsubscribe', selector: 'body.page-id-3343' },

      ##
      ##
      ##

      # /volunteer


      ##
      ## W
      ##

      # /wasyaco

      # { path: '/w/20221024',         redirect_to: 'https://staging.infiniteshelter.com/en/locations/show/austin-wasyaco' },

      { path: '/w/c',                 redirect_to: '/contact-us/project-intake' },
      { path: '/w/c2',                redirect_to: '/services/consulting' },
      { path: '/w/contact-us',        redirect_to: '/contact-us/contact-us-step1' },
      { path: '/w/pimsleur',          redirect_to: '/es/pimsleur-ingles-para-espanol' },
      { path: '/w/pudeyev-resume',    redirect_to: '/pudeyev-resume' },
      { path: '/w/unsubscribe',       redirect_to: '/unsubscribe' },

    ]
    return out
  end
end

