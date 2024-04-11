# == Schema Information
#
# Table name: clients
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  engaged                :boolean          default(FALSE), not null
#  industry               :integer          default("飲食"), not null
#  name                   :string(255)
#  our_business           :text(65535)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_clients_on_email                 (email) UNIQUE
#  index_clients_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :client do
    email                 { Faker::Internet.unique.email }
    password              { Faker::Internet.password(min_length: 6) }
    password_confirmation { password }
    confirmed_at { Faker::Time.between(from: 10.days.ago, to: Time.zone.now) }

    trait :with_profile do
      name { Faker::Company.name }
      our_business { Faker::Lorem.sentence(word_count: 25) }
      industry { %w[飲食 製造 IT 建築 サービス その他].sample }
    end
  end
end
