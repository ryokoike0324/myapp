require 'rails_helper'

RSpec.describe Contact do

  it 'name/email/subject/messageがあるインスタンスはバリデーションを通過する' do
    contact = build(:contact)
    expect(contact).to be_valid
  end

  it 'nameがないインスタンスはバリデーションを通過しない' do
    contact = build(:contact, name: nil)
    contact.valid?
    expect(contact.errors[:name]).to include('を入力してください')
  end

  it 'emailがないインスタンスはバリデーションを通過しない' do
    contact = build(:contact, email: nil)
    contact.valid?
    expect(contact.errors[:email]).to include('を入力してください')
  end

  it 'subjectがないインスタンスはバリデーションを通過しない' do
    contact = build(:contact, subject: nil)
    contact.valid?
    expect(contact.errors[:subject]).to include('を入力してください')
  end

  it 'messageがないインスタンスはバリデーションを通過しない' do
    contact = build(:contact, message: nil)
    contact.valid?
    expect(contact.errors[:message]).to include('を入力してください')
  end



end
