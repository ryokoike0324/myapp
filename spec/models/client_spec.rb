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
      expect(client.errors[:email]).to include('を入力してください')
    end

    it 'passwordがなければ登録できない' do
      client = build(:client, password: nil)
      client.valid?
      expect(client.errors[:password]).to include('を入力してください')
    end

    it 'passwordとpassword_confirmationが一致しなければ登録できない' do
      client = build(:client, password: 'hogehoge', password_confirmation: 'foobar')
      client.valid?
      expect(client.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
    end

  end

  describe 'ゲストユーザー' do
    it '正しい値が登録されていること' do
      guest = described_class.guest
      expect(guest).to be_valid
    end
  end
end
