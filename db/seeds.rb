# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# 画像データをもつ受注者（１人だけつくる画像をいちいち準備するのが面倒）
Contractor.create!(
  email: Faker::Internet.unique.email,
  password: Faker::Internet.password,
  confirmed_at: Time.zone.now,
  name: Faker::Name.name,
  public_relations: Faker::Lorem.sentence(word_count: 25),
  portfolio: Faker::Internet.unique.url,
  study_period: %w[３ヶ月未満 ６ヶ月未満 １年未満 １年以上].sample,
  image: File.open('./app/assets/images/sample-man1.png')
)
100.times do
  client = Client.create!(
    email: Faker::Internet.unique.email,
    password: Faker::Internet.password,
    confirmed_at: Time.zone.now,
    name: Faker::Company.name,
    our_business: Faker::Lorem.sentence(word_count: 25),
    industry: %w[飲食 製造 IT 建築 サービス その他].sample
  )
  client.create_request!(
    title: Faker::Job.title,
    deadline: Faker::Date.between(from: '2024-04-01', to: '2024-04-30'),
    delivery_date: Faker::Date.between(from: '2024-05-01', to: '2024-05-31'),
    description: Faker::Lorem.sentence(word_count: 25)
  )
end

