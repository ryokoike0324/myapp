class ContactMailer < ApplicationMailer

  def contact_mail(contact)
    @contact = contact
    mails = [ENV.fetch('MAILER_ADDRESS'), @contact.email]
    mail to:   mails, subject: '【First Step事務局】お問い合わせ内容の確認'
  end

end
