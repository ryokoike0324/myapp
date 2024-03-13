# == Schema Information
#
# Table name: contractors
#
#  id                     :bigint           not null, primary key
#  applied                :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  contracted             :boolean          default(FALSE), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  image                  :string(255)
#  name                   :string(255)
#  portfolio              :string(255)
#  public_relations       :text(65535)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  study_period           :integer          default("３ヶ月未満"), not null
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_contractors_on_email                 (email) UNIQUE
#  index_contractors_on_reset_password_token  (reset_password_token) UNIQUE
#
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
      image { Rack::Test::UploadedFile.new(Rails.root.join('spec/files/test-avator.png'), 'image/png') }

    end

  end
end
