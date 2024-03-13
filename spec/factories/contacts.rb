# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  email      :string(255)      not null
#  message    :text(65535)      not null
#  name       :string(255)      not null
#  subject    :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :contact do
    name { 'ryokoike' }
    email { 'ryokoike@gmail.com' }
    subject { 'お問い合わせです' }
    message { 'お世話になります' }
  end
end
