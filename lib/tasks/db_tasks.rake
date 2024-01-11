
namespace :db do

  desc "seed"
  task seed: :environment do
    inbox = Wco::Tag.find_or_create_by({ slug: 'inbox' })
    trash = Wco::Tag.find_or_create_by({ slug: 'trash' })

    poxlovi = Wco::Lead.find_or_create_by!({ email: 'poxlovi@gmail.com' })
  end

end
