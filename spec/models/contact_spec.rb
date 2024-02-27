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
      expect(contact.errors[:name]).to include('を入力してください')
    end

    it 'emailがないと登録できない' do
      contact.email = nil
      contact.valid?
      expect(contact.errors[:email]).to include('を入力してください')
    end

    it 'subjectがないと登録できない' do
      contact.subject = nil
      contact.valid?
      expect(contact.errors[:subject]).to include('を入力してください')
    end

    it 'messageがないと登録できない' do
      contact.message = nil
      contact.valid?
      expect(contact.errors[:message]).to include('を入力してください')
    end
  end


end
