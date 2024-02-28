FactoryBot.define do
  factory :contractor do
    email { Faker::Internet.unique.email }
    password              { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    confirmed_at { Time.zone.now }

    trait :with_profile do
      name { Faker::Name.name }
      image { Faker::Avatar.image }
      public_relations { Faker::Lorem.sentence(word_count: 25) }
      portfolio { Faker::Internet.unique.url }
      study_period { '１年未満' }
    end

  end
end
