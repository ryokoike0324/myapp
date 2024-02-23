class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |client|
      client.password = SecureRandom.urlsafe_base64
      client.name = 'ゲスト発注者'
      client.confirmed_at = Time.now  # Confirmable を使用している場合は必要
      # 例えば name を入力必須としているならば， client.name = 'ゲスト' なども必要
    end
  end
end
