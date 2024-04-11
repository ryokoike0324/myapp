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
require 'rails_helper'

RSpec.describe Client do
  describe 'バリデーション' do

    it 'email、passwordとpassword_confirmationが存在すれば登録できること' do
      client = build(:client)
      expect(client).to be_valid  # user.valid? が true になればパスする
    end

    it 'emailがなければ登録できない' do
      client = build(:client, email: nil)
      client.valid?
      expect(client.errors[:email]).to include('メールアドレスを入力して下さい')
    end

    it 'passwordがなければ登録できない' do
      client = build(:client, password: nil)
      client.valid?
      expect(client.errors[:password]).to include('パスワードを入力して下さい。')
    end

    it 'passwordとpassword_confirmationが一致しなければ登録できない' do
      client = build(:client, password: 'hogehoge', password_confirmation: 'foobar')
      client.valid?
      expect(client.errors[:password_confirmation]).to include('入力されたパスワードと一致しません。')
    end

  end

  describe 'ゲストユーザー' do
    it '正しい値が登録されていること' do
      guest = described_class.guest
      expect(guest).to be_valid
    end
  end
end
