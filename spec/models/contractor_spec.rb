# == Schema Information
#
# Table name: contractors
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  contracted             :boolean          default(FALSE), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  image                  :string(255)
#  name                   :string(255)
#  portfolio              :string(255)
#  public_relations       :text(65535)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  study_period           :integer          default("３ヶ月未満"), not null
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_contractors_on_email                 (email) UNIQUE
#  index_contractors_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe Contractor do
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
      expect(contractor.errors[:password_confirmation]).to include('とパスワードの入力が一致しません')
    end
  end

  describe 'ゲストユーザー' do
    it '正しい値が登録されていること' do
      guest = described_class.guest
      expect(guest).to be_valid
    end
  end
end
