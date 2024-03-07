FactoryBot.define do
  factory :request do
    title { "MyString" }
    deadline { "MyString" }
    delivery_date { "2024-03-07 10:49:30" }
    applicants_count { 1 }
    description { "MyText" }
    client_id { nil }
    contractor_id { nil }
  end
end
