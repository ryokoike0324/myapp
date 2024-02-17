FactoryBot.define do
  factory :contact do
    name { 'ryokoike' }
    email { 'ryokoike@gmail.com' }
    subject { 'お問い合わせです' }
    message { 'お世話になります' }
  end
end
