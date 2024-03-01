require 'rack/test'

FactoryBot.define do
  factory :contractor do
    email { Faker::Internet.unique.email }
    password              { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    confirmed_at { Time.zone.now }

    trait :with_profile do
      name { Faker::Name.name }
      # image { "#{Rails.root}/spec/files/test-avator.png" }
      public_relations { Faker::Lorem.sentence(word_count: 25) }
      portfolio { Faker::Internet.unique.url }
      study_period { %w[３ヶ月未満 ６ヶ月未満 １年未満 １年以上].sample }
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'test-avator.png'), 'image/png') }

    end

  end
end
