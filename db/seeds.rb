# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# 画像データをもつ受注者（１人だけつくる。全員分画像を準備するのが面倒のため）
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
# Contractorのサンプルデータを５名分作成
50.times do
  Contractor.create!(
    email: Faker::Internet.unique.email,
    password: 'password',
    confirmed_at: Time.zone.now,
    name: Faker::Name.name,
    public_relations: Faker::Lorem.sentence(word_count: 25),
    portfolio: Faker::Internet.unique.url,
    study_period: %w[３ヶ月未満 ６ヶ月未満 １年未満 １年以上].sample,
  )
end

100.times do
  client = Client.create!(
    email: Faker::Internet.unique.email,
    password: Faker::Internet.password,
    confirmed_at: Time.zone.now,
    name: Faker::Company.name,
    our_business: Faker::Lorem.sentence(word_count: 25),
    industry: %w[飲食 製造 IT 建築 サービス その他].sample
  )
  deadline_from = 1.month.from_now
  deadline_to = deadline_from + 2.weeks
  delivery_date_from = deadline_from + 1.month
  delivery_date_to = delivery_date_from + 2.weeks
  request = client.requests.create!(
    title: Faker::Job.title,
    deadline: Faker::Date.between(from: deadline_from, to: deadline_to),
    delivery_date: Faker::Date.between(from: delivery_date_from, to: delivery_date_to),
    description: Faker::Lorem.sentence(word_count: 100)
  )
  # 各Requestに対してランダムに選んだ5人のContractorが応募するデータを生成（重複を防ぐ）
  # Arel（Active Record Relation）ライブラリ、生のSQLスニペットを安全にActiveRecordクエリに組み込む方法
  # limit(5)：並び替えられた結果セットから最初の5レコードのみを取得
  contractors_sample = Contractor.order(Arel.sql('RAND()')).limit(5)
  contractors_sample.each do |contractor|
    # このContractorが既にこのRequestに応募している場合は、ループをスキップする
    next if request.applicants.include?(contractor)

      RequestApplication.create!(
        request:,
        contractor:
      )
  end
end
