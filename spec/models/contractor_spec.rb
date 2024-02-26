require 'rails_helper'

RSpec.describe 'Contractorモデル' do
  describe 'バリデーション' do

    it 'email/password/password_confirmationが存在すれば登録できること' do
      contractor = build(:contractor)
      expect(contractor).to be_valid  # user.valid? が true になればパスする
    end

    it 'emailがなければ登録できない' do
      contractor = build(:contractor, email: nil)
      contractor.valid?
      expect(contractor.errors[:email]).to include('を入力してください')
    end

    it 'passwordがなければ登録できない' do
      contractor = build(:contractor, password: nil)
      contractor.valid?
      expect(contractor.errors[:password]).to include('を入力してください')
    end

    it 'passwordとpassword_confirmationが一致しなければ登録できない' do
      contractor = build(:contractor, password: 'hogehoge', password_confirmation: 'foobar')
      contractor.valid?
      expect(contractor.errors[:password_confirmation]).to include('とPasswordの入力が一致しません')
    end
  end

  describe 'ゲストユーザー' do
    it '正しい値が登録されていること' do
      guest = Client.guest
      expect(guest).to be_valid
    end
  end
end
