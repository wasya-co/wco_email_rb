
= Install =

  alias dc='docker-compose '

Copy and edit the config file:

  cp _env .env

Check out the repository and run:

  bundle

Ask Victor to add your user (email) to the remote auth server. Or use test-1@wasya.co

Note: the mongodb port is 27041.

  dc up -d mongo_development
  dc up -d localstack_development

In the rails console ( cd test/dummy ; be rails c ):

  profile = Wco::Profile.create email: 'test-1@wasya.co'
  inbox   = Wco::Tag.create slug: 'inbox'

You need a copy of wco_models.git locally ( default location is ~/projects/ruby/wco_models )

== Troubleshooting ==

Issue:

  checking for yaml.h... no
  yaml.h not found

Solution:

  brew install libyaml

= Use =
  cd test/dummy
  be sidekiq -q wco_email_rb_mailers -q wco_email_rb_default -q wco_email_rb
