class ContactMailer < ApplicationMailer

  def contact_mail(contact)
    @contact = contact
    mails = [ENV.fetch('MAILER_ADDRESS'), @contact.email]
    mail to:   mails, subject: t('contact_mailer.contact_mail.subject')
  end

end
