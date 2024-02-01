
namespace :db do

  desc "clean contexts"
  task clean_contexts: :environment do
    WcoEmail::Context.each do |ttt|
      if !ttt.lead
        ttt.delete
      end
    end
  end

  desc 'clean email actions'
  task clean_email_actions: :environment do
    WcoEmail::EmailAction.each do |act|
      if !act.lead
        act.delete
      end
    end
  end

  desc "seed"
  task seed: :environment do

    blank_email_template = WcoEmail::EmailTemplate.find_or_create_by({ slug: 'blank' })

    inbox = Wco::Tag.find_or_create_by({ slug: 'inbox' })
    trash = Wco::Tag.find_or_create_by({ slug: 'trash' })
    spam  = Wco::Tag.find_or_create_by({ slug: 'spam' })

    wasyaco  = Wco::Leadset.find_or_create_by!({ company_url: 'wasya.co' })

    poxlovi  = Wco::Lead.find_or_create_by!({ email: 'poxlovi@gmail.com' })
    piousbox = Wco::Lead.find_or_create_by!({ email: 'piousbox@gmail.com' })
    victor   = Wco::Lead.find_or_create_by!({ email: 'victor@wasya.co' })

  end

end
