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
class Client < ApplicationRecord
  # ポリモーフィックスの関連付け
  has_many :sent_notifications, as: :sender, class_name: 'Notification', dependent: :destroy
  has_many :received_notifications, as: :recipient, class_name: 'Notification', dependent: :destroy
  # 多数の仕事を発注できる
  has_many :requests, dependent: :destroy
  has_one :engagement, dependent: :destroy
  has_one :contractor, through: :engagement
  enum industry: { 飲食: 0, 製造: 1, IT: 2, 建築: 3, サービス: 4, その他: 5 }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def self.guest
    guest_client = find_or_create_by!(email: 'guest-client@example.com') do |client|
      client.password = SecureRandom.urlsafe_base64
      client.name = 'ゲスト発注者'
      # Confirmable を使用している場合は必要
      client.confirmed_at = Time.zone.now
      client.our_business = 'ゲスト発注者の事業内容欄です。お好きに編集して下さい。'
    end
    # 既存の関連 Request が存在しない場合にのみ新たに作成
    if guest_client.requests.blank?
      request = guest_client.requests.create(
        title: 'ゲスト発注者のお仕事投稿タイトル',
        description: 'ゲスト発注者のお仕事情報詳細欄です。お好きに編集して下さい。',
        deadline: 1.week.from_now,
        delivery_date: 2.weeks.from_now
      )
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
    guest_client
  end
end
