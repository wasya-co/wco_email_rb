

FactoryBot.define do

  # alphabetized : )

  # sequence :email do |n|
  #   "test-#{n}@email.com"
  # end


  factory :email_conversation, class: WcoEmail::Conversation do
  end

  # factory :gallery do
  #   name      { generate(:slug) }
  #   slug      { generate(:slug) }
  #   is_trash  { false }
  #   is_public { true }
  #   after :build do |g|
  #     g.slug ||= name
  #   end
  # end


  factory :tag, class: Wco::Tag do
  end

end
