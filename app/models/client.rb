class Client < ApplicationRecord
  enum industry: { 飲食: 0, 製造: 1, IT: 2, 建築: 3, サービス: 4, その他: 5 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def self.guest
    find_or_create_by!(email: 'guest-client@example.com') do |client|
      client.password = SecureRandom.urlsafe_base64
      client.name = 'ゲスト発注者'
      client.confirmed_at = Time.zone.now  # Confirmable を使用している場合は必要
      # 例えば name を入力必須としているならば， client.name = 'ゲスト' なども必要
    end
  end
end
