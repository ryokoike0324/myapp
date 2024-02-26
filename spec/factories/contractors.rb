FactoryBot.define do
  factory :contractor do
    email                 { 'test@gmail.com' }
    password              { '111111' }
    password_confirmation { '111111' }
    confirmed_at { Time.zone.now }
  end
end
