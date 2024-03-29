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
require 'rails_helper'

RSpec.describe Contact do
  describe 'バリデーション' do
    let(:contact){ build(:contact) }

    it 'name/email/subject/messageが存在すれば登録できること' do
      expect(contact).to be_valid
    end

    it 'nameがないと登録できない' do
      contact.name = nil
      contact.valid?
      expect(contact.errors[:name]).to include('お名前を入力してください')
    end

    it 'emailがないと登録できない' do
      contact.email = nil
      contact.valid?
      expect(contact.errors[:email]).to include('メールアドレスを入力してください')
    end

    it 'subjectがないと登録できない' do
      contact.subject = nil
      contact.valid?
      expect(contact.errors[:subject]).to include('件名を入力してください')
    end

    it 'messageがないと登録できない' do
      contact.message = nil
      contact.valid?
      expect(contact.errors[:message]).to include('お問い合わせ内容を入力してください')
    end
  end


end
