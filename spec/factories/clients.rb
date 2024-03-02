FactoryBot.define do
  factory :client do
    email                 { Faker::Internet.unique.email }
    password              { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    confirmed_at { Time.zone.now }

    trait :with_profile do
      name { Faker::Company.name }
      our_business { Faker::Lorem.sentence(word_count: 25) }
      industry { %w[飲食 製造 IT 建築 サービス その他].sample }
    end
  end
end
