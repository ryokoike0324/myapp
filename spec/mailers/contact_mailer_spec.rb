require 'rails_helper'

RSpec.describe ContactMailer, type: :mailer do
  describe 'お問い合わせメール' do
    let(:contact) do
      Contact.new(
        name: 'テストユーザー',
        email: 'test@exmple.com',
        subject: 'test_contact_mailのsubjectです',
        message: 'test_contact_mailのmessageです'
      )
    end
    let(:mail){ described_class.contact_mail(contact) }

    it '宛先(to)がユーザーと管理者であること' do
      expect(mail.to).to eq [ENV.fetch('MAILER_ADDRESS'), contact.email]
    end

    it '送信元(from)が【First Step事務局】であること' do
      expect(mail.from).to eq 'First Step事務局'
    end

    it '件名(subject)が正しいこと' do
      expect(mail.subject).to eq '【First Step事務局】お問い合わせ内容の確認'
    end

    it 'HTMLのメール本文が正しく表示されていること' do
      mail.deliver_now
      last_mail = ActionMailer::Base.deliveries.last
      # HTMLのパートからテキストを取得
      html_part = last_mail.html_part.body.decoded
      expect(html_part).to match(contact.name)
      expect(html_part).to match(contact.subject)
      expect(html_part).to match(contact.message)
      expect(html_part).to match('この度は、お問い合わせありがとうございました。')
    end

    it 'TEXTのメール本文が正しく表示されていること' do
      mail.deliver_now
      last_mail = ActionMailer::Base.deliveries.last
      # テキストのパートからテキストを取得
      text_part = last_mail.text_part.body.decoded
      expect(text_part).to match(contact.name)
      expect(text_part).to match(contact.subject)
      expect(text_part).to match(contact.message)
      expect(text_part).to match('この度は、お問い合わせありがとうございました。')
    end

    it '実際にメールを送り、作成できているか' do
      expect do
        mail.deliver_now
      end.to change{ ActionMailer::Base.deliveries.size }.by(1)
    end

  end
end
