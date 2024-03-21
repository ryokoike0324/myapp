# == Schema Information
#
# Table name: requests
#
#  id            :bigint           not null, primary key
#  deadline      :datetime         not null
#  delivery_date :datetime         not null
#  description   :text(65535)      not null
#  title         :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  client_id     :bigint           not null
#
# Indexes
#
#  index_requests_on_client_id  (client_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#
FactoryBot.define do
  factory :request do
    title { Faker::Job.title }
    deadline { Faker::Date.between(from: '2024-04-01', to: '2024-04-30') }
    delivery_date { Faker::Date.between(from: '2024-05-01', to: '2024-05-31')  }
    description { Faker::Lorem.sentence(word_count: 25) }
    client
  end
end
