
namespace :db do

  desc "seed"
  task seed: :environment do
    inbox = Wco::Tag.find_or_create_by({ slug: 'inbox' })
    trash = Wco::Tag.find_or_create_by({ slug: 'trash' })
  end

end
